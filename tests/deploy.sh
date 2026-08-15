#!/usr/bin/env bash
set -Eeuo pipefail
[[ ${TRACE_TESTS:-0} == 0 ]] || set -x
S=${DEPLOY_SCRIPT:?}; C=${CONSUMER_SCRIPT:-}; TEST_BASH=${TEST_BASH:-bash}; T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
mkdir "$T/bin"; LOG=$T/log; export LOG
for c in nix nix-instantiate nix-store deploy-rs lab-update jj; do cat >"$T/bin/$c" <<'MOCK'
#!/usr/bin/env bash
command=$(basename "$0")
[[ -z ${DEPLOY_GITHUB_TOKEN+x} ]] || exit 88
echo "$command $*${DEPLOY_PROBE_SYSTEM:+ system=$DEPLOY_PROBE_SYSTEM}" >>"$LOG"
[[ $command != deploy-rs || -z ${DEPLOY_GITHUB_TOKEN+x} ]] || exit 89
[[ $command != deploy-rs || ${*: -1} != *"${FAIL_HOST:-__never__}"* ]] || exit 1
case $command in
  nix-instantiate) ln -sf /nix/store/probe.drv "${3:?}"; echo "$3";;
  nix-store) echo /nix/store/probe-output;;
esac
MOCK
chmod +x "$T/bin/$c"; done
cat >"$T/bin/gh" <<'MOCK'
#!/usr/bin/env bash
[[ -z ${DEPLOY_GITHUB_TOKEN+x} ]] || exit 88
echo "gh $*" >>"$LOG"
[[ ${GH_FAIL:-0} == 0 ]] || exit 1
printf '%s\n' 'ghp_123456789012345678901234567890123456'
MOCK
cat >"$T/bin/ssh" <<'MOCK'
#!/usr/bin/env bash
[[ -z ${DEPLOY_GITHUB_TOKEN+x} ]] || exit 88
printf 'ssh argv' >>"$LOG"; printf ' %q' "$@" >>"$LOG"; echo >>"$LOG"
command=${*: -1}; remote_home=$TEST_REMOTE_HOME; mkdir -p "$remote_home/.local/state"
if [[ $command == bash\ -c* ]]; then
  HOME=$remote_home XDG_STATE_HOME=$remote_home/.local/state USER=$(id -un) bash -c "$command"
  file=$remote_home/.local/state/dotfiles-deploy/github-api
  [[ -f $file && $(stat -c %a "$file") == 600 ]] || exit 91
  grep -qx 'ghp_123456789012345678901234567890123456' "$file" || exit 92
  echo 'ssh staged-stdin-ok' >>"$LOG"
  [[ ${SSH_STAGE_FAIL:-0} == 0 ]] || exit 93
else
  if [[ ${CLEANUP_FAIL_ONCE:-0} == 1 && ! -e $remote_home/cleanup-failed ]]; then touch "$remote_home/cleanup-failed"; exit 94; fi
  HOME=$remote_home XDG_STATE_HOME=$remote_home/.local/state USER=$(id -un) bash -c "$command"
  echo 'ssh cleanup' >>"$LOG"
fi
MOCK
chmod +x "$T/bin/gh" "$T/bin/ssh"
cat >"$T/bin/uname" <<'MOCK'
#!/usr/bin/env bash
[[ ${1:-} == -n ]] || exit 2
echo "${MOCK_HOSTNAME:-client}"
MOCK
chmod +x "$T/bin/uname"
cat >"$T/inventory" <<'EOF'
poseidon	nixos	x86_64-linux	github-api
zeus	nixos	x86_64-linux	github-api
hades	nixos	x86_64-linux	-
eris	darwin	aarch64-darwin	-
EOF
export TEST_REMOTE_HOME=$T/remote
export PATH="$T/bin:$PATH" DEPLOY_FLAKE=/source DEPLOY_INVENTORY="$T/inventory" DEPLOY_RS="$T/bin/deploy-rs" LAB_UPDATE="$T/bin/lab-update"
OUT=$T/stdout ERR=$T/stderr
run() { : >"$LOG"; : >"$OUT"; : >"$ERR"; "$TEST_BASH" "$S" "$@" >"$OUT" 2>"$ERR"; }
expect_failure() { if "$@"; then echo "expected failure: $*" >&2; return 1; fi; }
run --help; [[ ! -s $LOG ]]
expect_failure run unknown; [[ ! -s $LOG ]]
expect_failure run charon; [[ ! -s $LOG ]]
run hades; grep -Fq 'nix eval --json --no-write-lock-file /source#deploy.nodes.hades' "$LOG"; grep -Fq -- 'deploy-rs --skip-checks --remote-build /source#hades' "$LOG"; expect_failure grep -q interactive-sudo "$LOG"
for pair in '--dry-activate --dry-activate' '--test --test' '--boot --boot'; do read -r wrapper cli <<<"$pair"; run "$wrapper" hades; grep -Fq "deploy-rs $cli --skip-checks --remote-build /source#hades" "$LOG"; done
DEPLOY_GITHUB_TOKEN=ghp_123456789012345678901234567890123456 run hades; [[ $(grep -c '^deploy-rs ' "$LOG") == 1 && $(grep -c '^ssh ' "$LOG") == 0 ]]
DEPLOY_GITHUB_TOKEN=ghp_123456789012345678901234567890123456 run --boot poseidon; [[ $(grep -c '^deploy-rs ' "$LOG") == 1 && $(grep -c '^ssh ' "$LOG") == 0 && $(grep -c '^gh ' "$LOG") == 0 ]]
GH_FAIL=1 DEPLOY_GITHUB_TOKEN=bad run --dry-activate poseidon; [[ $(grep -c '^gh auth token' "$LOG") == 1 && $(grep -c '^ssh ' "$LOG") == 0 ]]; grep -q 'warning:' "$ERR"
run --dry-activate poseidon; [[ $(grep -c '^ssh ' "$LOG") == 0 ]]
run --dry-activate eris; grep -Fq 'deploy-rs --dry-activate --skip-checks --remote-build /source#eris' "$LOG"
run poseidon; [[ $(grep -c '^gh auth token' "$LOG") == 1 && $(grep -c '^ssh staged-stdin-ok' "$LOG") == 1 && $(grep -c '^ssh cleanup' "$LOG") == 1 ]]
[[ ! -e $TEST_REMOTE_HOME/.local/state/dotfiles-deploy/github-api ]]
if grep -q 'ghp_' "$LOG" "$OUT" "$ERR"; then exit 1; fi
DEPLOY_GITHUB_TOKEN=ghp_123456789012345678901234567890123456; export DEPLOY_GITHUB_TOKEN; run poseidon; unset DEPLOY_GITHUB_TOKEN
DEPLOY_GITHUB_TOKEN=ghp_123456789012345678901234567890123456; export DEPLOY_GITHUB_TOKEN; GH_FAIL=1; export GH_FAIL; run --dry-activate poseidon; [[ $(grep -c '^gh ' "$LOG") == 0 && ! -s $ERR ]]; unset GH_FAIL DEPLOY_GITHUB_TOKEN
CLEANUP_FAIL_ONCE=1; export CLEANUP_FAIL_ONCE; rm -f "$TEST_REMOTE_HOME/cleanup-failed"; run poseidon; [[ ! -e $TEST_REMOTE_HOME/.local/state/dotfiles-deploy/github-api && $(grep -c '^ssh argv' "$LOG") == 3 ]]; unset CLEANUP_FAIL_ONCE
GH_FAIL=1; export GH_FAIL; expect_failure run zeus; [[ $(grep -c '^gh ' "$LOG") == 1 ]]; if grep -Eq '^(nix|deploy-rs|ssh) ' "$LOG"; then exit 1; fi; unset GH_FAIL
run --dry-activate lab; [[ $(grep -c '^deploy-rs ' "$LOG") == 4 ]]
for unsafe in test boot; do
  expect_failure run "--$unsafe" eris; [[ ! -s $LOG ]]
  expect_failure run "--$unsafe" lab; [[ ! -s $LOG ]]
done
export FAIL_HOST='#zeus'; expect_failure run lab; [[ $(grep -c '^deploy-rs ' "$LOG") == 2 && $(grep -c '^gh auth token' "$LOG") == 1 ]]; [[ ! -e $TEST_REMOTE_HOME/.local/state/dotfiles-deploy/github-api ]]; unset FAIL_HOST
SSH_STAGE_FAIL=1; export SSH_STAGE_FAIL; expect_failure run poseidon; [[ ! -e $TEST_REMOTE_HOME/.local/state/dotfiles-deploy/github-api ]]; unset SSH_STAGE_FAIL
MOCK_HOSTNAME=hades; export MOCK_HOSTNAME; expect_failure run hades; [[ ! -s $LOG ]]; expect_failure run lab; [[ ! -s $LOG ]]; unset MOCK_HOSTNAME
run --assure hades; grep -Fq 'jj root' "$LOG"; grep -Fq 'lab-update --dry-run hades' "$LOG"; grep -Fq 'lab-update hades' "$LOG"
expect_failure run --assure eris
expect_failure run probe charon
printf 'probe hades\n' >"$T/tty"; export DEPLOY_TTY_PATH="$T/tty"
run probe hades
grep -Fq 'nix-instantiate --impure --add-root ' "$LOG"
grep -Fq 'system=x86_64-linux' "$LOG"
grep -Fq 'nix copy --to ssh-ng://chant@hades /nix/store/probe.drv' "$LOG"
grep -Fq 'nix-store --store ssh-ng://chant@hades --no-gc-warning --realise /nix/store/probe.drv' "$LOG"
unset DEPLOY_TTY_PATH
if [[ -n $C ]]; then
  consumer_home=$T/home; mkdir -p "$consumer_home/.local/state/dotfiles-deploy"; chmod 700 "$consumer_home/.local/state/dotfiles-deploy"
  credential=$consumer_home/.local/state/dotfiles-deploy/github-api
  printf '%s\n' 'ghp_123456789012345678901234567890123456' >"$credential"; chmod 600 "$credential"
  [[ $(env -u USER HOME="$consumer_home" "$TEST_BASH" "$C" github-api) == ghp_* && ! -e $credential ]]
  { printf g; head -c 511 /dev/zero | tr '\0' a; printf '\n'; } >"$credential"; chmod 600 "$credential"; [[ $(env -u USER HOME="$consumer_home" "$TEST_BASH" "$C" github-api | wc -c) == 513 && ! -e $credential ]]
  printf x >"$credential"; chmod 644 "$credential"; expect_failure env HOME="$consumer_home" USER="$(id -un)" "$TEST_BASH" "$C" github-api; [[ ! -e $credential ]]
  printf short >"$credential"; chmod 600 "$credential"; expect_failure env HOME="$consumer_home" USER="$(id -un)" "$TEST_BASH" "$C" github-api; [[ ! -e $credential ]]
  head -c 514 /dev/zero | tr '\0' a >"$credential"; chmod 600 "$credential"; expect_failure env HOME="$consumer_home" USER="$(id -un)" "$TEST_BASH" "$C" github-api; [[ ! -e $credential ]]
  printf '%s\n' 'ghp_123456789012345678901234567890123456' >"$credential"; chmod 600 "$credential"; touch -d '13 hours ago' "$credential"; expect_failure env HOME="$consumer_home" USER="$(id -un)" "$TEST_BASH" "$C" github-api; [[ ! -e $credential ]]
  ln -s "$T/elsewhere" "$credential"; expect_failure env HOME="$consumer_home" USER="$(id -un)" "$TEST_BASH" "$C" github-api; [[ ! -L $credential ]]
  chmod 755 "$consumer_home/.local/state/dotfiles-deploy"; printf '%s\n' 'ghp_123456789012345678901234567890123456' >"$credential"; chmod 600 "$credential"; expect_failure env HOME="$consumer_home" USER="$(id -un)" "$TEST_BASH" "$C" github-api; [[ ! -e $credential ]]; chmod 700 "$consumer_home/.local/state/dotfiles-deploy"
fi
echo 'deploy hermetic tests: ok'
