#!/usr/bin/env bash
# Conservatively update GitHub flake inputs. Nix, not this script, produces the lock.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./update.sh [--dry-run] [--urgent-security-bypass] [--no-build]

By default, only commits at least 72 hours old are selected. The urgent security
bypass selects current commits and disables the age gate for ALL direct inputs
and every changed transitive GitHub node.
EOF
}

dry_run=false; urgent=false; no_build=false
while (($#)); do
  case $1 in
    --dry-run) dry_run=true ;;
    --urgent-security-bypass) urgent=true ;;
    --no-build) no_build=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done
$urgent && echo 'URGENT SECURITY BYPASS ACTIVE for ALL inputs: the 72-hour age gate is disabled.' >&2

for tool in nix jq curl; do
  command -v "$tool" >/dev/null || { echo "error: required command not found: $tool" >&2; exit 1; }
done
[[ -f flake.lock ]] || { echo 'error: run this script from the repository root' >&2; exit 1; }

lock_dir=.flake-update.lock
if ! mkdir "$lock_dir" 2>/dev/null; then
  echo 'error: another update is already running (or stale .flake-update.lock exists)' >&2
  exit 1
fi
work=$(mktemp -d "${TMPDIR:-/tmp}/flake-update.XXXXXX")
candidate=$(mktemp ./.flake.lock.candidate.XXXXXX); rm -f "$candidate"
cleanup() { rm -rf "$work" "$lock_dir"; rm -f "$candidate"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

now=$(date +%s)
[[ $now =~ ^[0-9]+$ ]] || { echo 'error: invalid current time' >&2; exit 1; }
cutoff=$((now - 72 * 60 * 60))
cutoff_iso=$(jq -enr --argjson t "$cutoff" '$t | strftime("%Y-%m-%dT%H:%M:%SZ")')

curl_config=$work/curl.conf
: >"$curl_config"; chmod 600 "$curl_config"
# A protected config file keeps credentials out of argv and process listings.
if [[ -n ${GITHUB_TOKEN:-} ]]; then
  [[ $GITHUB_TOKEN =~ ^[A-Za-z0-9_]+$ ]] || { echo 'error: GITHUB_TOKEN contains unsafe characters' >&2; exit 1; }
  printf 'header = "Authorization: Bearer %s"\n' "$GITHUB_TOKEN" >>"$curl_config"
fi
printf '%s\n' 'header = "Accept: application/vnd.github+json"' >>"$curl_config"

api_commit() {
  local owner=$1 repo=$2 rev=$3 until=${4:-} body
  local args=(--get --data-urlencode "sha=$rev" --data-urlencode 'per_page=1')
  [[ -z $until ]] || args+=(--data-urlencode "until=$until")
  body=$(curl -fsSL --config "$curl_config" "${args[@]}" \
    "https://api.github.com/repos/$owner/$repo/commits") || return 1
  jq -er 'if type == "array" and length == 1
      and (.[0].sha | type == "string")
      and (.[0].commit.committer.date | type == "string")
    then {rev:.[0].sha,date:.[0].commit.committer.date}
    else error("GitHub returned no unambiguous commit") end' <<<"$body"
}

inputs_file=$work/inputs
if ! jq -er '.root as $r | .nodes[$r].inputs | to_entries
    | if length == 0 then error("no inputs") else .[] end
    | if (.value|type) == "string" then [.key,.value]|@tsv
      else error("indirect input mapping unsupported") end' flake.lock >"$inputs_file"; then
  echo 'error: cannot extract direct inputs from lock' >&2; exit 1
fi

overrides=()
while IFS=$'\t' read -r input node; do
  record=$(jq -er --arg n "$node" '.nodes[$n]
    | select(.original.type == "github" and .locked.type == "github")
    | select((.original.owner|type)=="string" and (.original.repo|type)=="string" and (.locked.rev|type)=="string")
    | {owner:.original.owner,repo:.original.repo,ref:(.original.ref // .original.rev // "HEAD"),current:.locked.rev}' flake.lock) || {
      echo "error: unsupported direct input '$input' (only GitHub inputs are safe)" >&2; exit 1;
    }
  owner=$(jq -er .owner <<<"$record"); repo=$(jq -er .repo <<<"$record")
  ref=$(jq -er .ref <<<"$record"); current=$(jq -er .current <<<"$record")
  if $urgent; then
    selected=$(api_commit "$owner" "$repo" "$ref") || { echo "error: GitHub lookup failed for $owner/$repo" >&2; exit 1; }
  else
    current_info=$(api_commit "$owner" "$repo" "$current") || { echo "error: GitHub lookup failed for current $owner/$repo" >&2; exit 1; }
    current_epoch=$(jq -er '.date|fromdateiso8601' <<<"$current_info") || { echo "error: invalid GitHub date for $input" >&2; exit 1; }
    if ((current_epoch > cutoff)); then
      selected=$current_info
      echo "Keeping fresh $input at $current (newer than cutoff)"
    else
      selected=$(api_commit "$owner" "$repo" "$ref" "$cutoff_iso") || { echo "error: no aged commit found for $owner/$repo" >&2; exit 1; }
    fi
  fi
  rev=$(jq -er .rev <<<"$selected")
  [[ $rev =~ ^[0-9a-fA-F]{40}$ ]] || { echo "error: GitHub returned invalid revision for $input" >&2; exit 1; }
  overrides+=(--override-input "$input" "github:$owner/$repo/$rev")
done <"$inputs_file"

nix flake update --output-lock-file "$candidate" "${overrides[@]}"
jq -e . "$candidate" >/dev/null

# Preserve original descriptors only for root direct inputs. Transitive originals
# legitimately belong to, and may change with, their upstream lock graph.
jq -e --slurpfile old flake.lock '
  . as $new | $old[0].root as $r
  | select($new.root == $r and $new.nodes[$r].inputs == $old[0].nodes[$r].inputs)
  | $old[0].nodes[$r].inputs | to_entries
  | all(.[]; (.value|type)=="string" and
      ((.value) as $n | .key as $name |
       ($old[0].nodes[$n].original != null) and
       ($new.nodes[$new.root].inputs[$name] == $n) and
       ($new.nodes[$n].original == $old[0].nodes[$n].original)))' "$candidate" >/dev/null || {
  echo 'error: candidate changed a direct input original reference' >&2; exit 1;
}

changed_file=$work/changed
if ! jq -er --slurpfile old flake.lock '
    .nodes as $new | [((($new|keys_unsorted) + ($old[0].nodes|keys_unsorted)) | unique[]) as $n
      | select($new[$n].locked != $old[0].nodes[$n].locked) | $n] | .[], ""' "$candidate" >"$changed_file"; then
  echo 'error: cannot determine changed lock nodes' >&2; exit 1
fi
changed_count=0
while IFS= read -r node; do
  [[ -n $node ]] || continue
  changed_count=$((changed_count + 1))
  info=$(jq -er --arg n "$node" '.nodes[$n].locked
    | select(.type=="github" and (.owner|type)=="string" and (.repo|type)=="string" and (.rev|type)=="string")
    | [.owner,.repo,.rev]|@tsv' "$candidate") || {
      echo "error: changed node '$node' is not a supported GitHub lock" >&2; exit 1;
    }
  IFS=$'\t' read -r owner repo rev <<<"$info"
  [[ $rev =~ ^[0-9a-fA-F]{40}$ ]] || { echo "error: invalid revision for changed node '$node'" >&2; exit 1; }
  verified=$(api_commit "$owner" "$repo" "$rev") || { echo "error: cannot verify changed node '$node'" >&2; exit 1; }
  verified_rev=$(jq -er .rev <<<"$verified") || exit 1
  [[ $verified_rev == "$rev" ]] || { echo "error: GitHub revision mismatch for '$node'" >&2; exit 1; }
  if ! $urgent; then
    epoch=$(jq -er '.date|fromdateiso8601' <<<"$verified") || { echo "error: invalid GitHub date for '$node'" >&2; exit 1; }
    ((epoch <= cutoff)) || { echo "error: changed node '$node' is newer than the 72-hour cutoff" >&2; exit 1; }
  fi
done <"$changed_file"

if $dry_run; then
  echo "Dry run: validated candidate with $changed_count changed node(s); flake.lock was not modified."
  exit 0
fi
mv "$candidate" flake.lock
if ! $no_build; then ./build.sh; fi
