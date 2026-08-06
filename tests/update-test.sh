#!/usr/bin/env bash
set -euo pipefail
# Hermetic security regression tests for update.sh; nix/curl/date are mocked.
root=$(cd "$(dirname "$0")/.." && pwd)
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
mkdir -p "$t/bin" "$t/repo"
cp "$root/update.sh" "$t/repo/"
real_jq=$(command -v jq)
cat >"$t/base" <<'JSON'
{"version":7,"root":"root","nodes":{"root":{"inputs":{"dep":"dep"}},"dep":{"inputs":{"nested":"nested"},"original":{"type":"github","owner":"o","repo":"direct","ref":"main"},"locked":{"type":"github","owner":"o","repo":"direct","rev":"1111111111111111111111111111111111111111","narHash":"a"}},"nested":{"original":{"type":"github","owner":"o","repo":"nested","ref":"old"},"locked":{"type":"github","owner":"o","repo":"nested","rev":"3333333333333333333333333333333333333333","narHash":"c"}}}}
JSON
cat >"$t/good" <<'JSON'
{"version":7,"root":"root","nodes":{"root":{"inputs":{"dep":"dep"}},"dep":{"inputs":{"nested":"nested"},"original":{"type":"github","owner":"o","repo":"direct","ref":"main"},"locked":{"type":"github","owner":"o","repo":"direct","rev":"2222222222222222222222222222222222222222","narHash":"b"}},"nested":{"original":{"type":"github","owner":"o","repo":"nested","ref":"new-upstream-ref"},"locked":{"type":"github","owner":"o","repo":"nested","rev":"4444444444444444444444444444444444444444","narHash":"d"}}}}
JSON
cat >"$t/bin/nix" <<'EOF'
#!/usr/bin/env bash
set -eu
while (($#)); do
  if [[ $1 == --output-lock-file ]]; then cp "$MOCK_CANDIDATE" "$2"; ${NIX_PAUSE:+sleep "$NIX_PAUSE"}; exit 0; fi
  shift
done
exit 1
EOF
cat >"$t/bin/date" <<'EOF'
#!/usr/bin/env bash
[[ ${1:-} == +%s ]] || exit 1
printf '%s\n' 1704067200
EOF
cat >"$t/bin/curl" <<'EOF'
#!/usr/bin/env bash
set -eu
printf '%s\n' "$*" >>"$CURL_LOG"
sha=; prev=
for arg; do
  [[ $prev == --data-urlencode && $arg == sha=* ]] && sha=${arg#sha=}
  prev=$arg
done
case $sha in
  1111111111111111111111111111111111111111) rev=$sha; d=${DATE_1:-2023-12-20T00:00:00Z} ;;
  2222222222222222222222222222222222222222) rev=$sha; d=${DATE_2:-2023-12-29T00:00:00Z} ;;
  3333333333333333333333333333333333333333) rev=$sha; d=2023-12-20T00:00:00Z ;;
  4444444444444444444444444444444444444444) rev=$sha; d=${DATE_4:-2023-12-29T00:00:00Z} ;;
  main) rev=2222222222222222222222222222222222222222; d=${DATE_2:-2023-12-29T00:00:00Z} ;;
  *) printf '[]\n'; exit 0 ;;
esac
[[ ${BAD_API:-} != 1 ]] || { printf '{broken\n'; exit 0; }
printf '[{"sha":"%s","commit":{"committer":{"date":"%s"}}}]\n' "$rev" "$d"
EOF
cat >"$t/bin/jq" <<'EOF'
#!/usr/bin/env bash
if [[ ${FAIL_CHANGED_JQ:-} == 1 && " $* " == *keys_unsorted* ]]; then exit 7; fi
exec "$REAL_JQ" "$@"
EOF
chmod +x "$t/bin/"*
cat >"$t/repo/build.sh" <<'EOF'
#!/usr/bin/env bash
echo built >>"$MARKER"
EOF
chmod +x "$t/repo/build.sh"
reset() { cp "$t/base" "$t/repo/flake.lock"; rm -f "$t/build" "$t/curl.log"; }
run() { (cd "$t/repo" && env PATH="$t/bin:$PATH" REAL_JQ="$real_jq" MOCK_CANDIDATE="$MOCK_CANDIDATE" CURL_LOG="$t/curl.log" MARKER="$t/build" "$@" ./update.sh "${ARGS[@]}"); }
reject() { if run "$@" >"$t/out" 2>&1; then echo "expected rejection: $*" >&2; exit 1; fi; cmp "$t/base" "$t/repo/flake.lock"; }
MOCK_CANDIDATE=$t/good

# Exact cutoff succeeds, dry-run is atomic, transitive original changes are allowed,
# and query values are passed through curl's URL encoder rather than concatenated.
reset; ARGS=(--dry-run); run >"$t/out"; cmp "$t/base" "$t/repo/flake.lock"
grep -q '2 changed node' "$t/out"; grep -q -- '--data-urlencode sha=' "$t/curl.log"; [[ ! -e $t/build ]]

# One second newer than cutoff on a genuine changed transitive node fails atomically.
reset; ARGS=(--no-build); reject DATE_4=2023-12-29T00:00:01Z
# Invalid API JSON and changed-node jq extraction both fail closed.
reset; reject BAD_API=1
reset; reject FAIL_CHANGED_JQ=1

# Changed non-GitHub and malformed GitHub nodes are rejected.
"$real_jq" '.nodes.nested.locked.type="git"' "$t/good" >"$t/nongithub"
reset; MOCK_CANDIDATE=$t/nongithub; reject
"$real_jq" 'del(.nodes.nested.locked.rev)' "$t/good" >"$t/invalid"
reset; MOCK_CANDIDATE=$t/invalid; reject
MOCK_CANDIDATE=$t/good

# A fresh current direct revision is retained, never downgraded to the aged selection.
"$real_jq" '.nodes.dep.locked.rev="1111111111111111111111111111111111111111" | .nodes.nested.locked.rev="3333333333333333333333333333333333333333" | .nodes.nested.original.ref="old"' "$t/base" >"$t/same"
reset; MOCK_CANDIDATE=$t/same; ARGS=(--dry-run); run DATE_1=2023-12-31T00:00:00Z >"$t/out"
grep -q 'Keeping fresh dep' "$t/out"

# Urgent all-input bypass is conspicuous and permits fresh direct/transitive changes.
reset; MOCK_CANDIDATE=$t/good; ARGS=(--urgent-security-bypass --no-build)
run DATE_2=2023-12-31T00:00:00Z DATE_4=2023-12-31T00:00:00Z >"$t/out" 2>&1
grep -q 'ALL inputs' "$t/out"; [[ ! -e $t/build ]]

# Argument errors are status 2. Concurrent attempts cannot both enter.
reset; ARGS=(--wat); set +e; run >"$t/out" 2>&1; status=$?; set -e; [[ $status == 2 ]]
reset; ARGS=(--dry-run); (run NIX_PAUSE=2 >"$t/first" 2>&1) & pid=$!; sleep 0.3
reject
wait "$pid"

echo 'update tests passed'
