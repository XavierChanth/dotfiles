#!/usr/bin/env bash
set -Eeuo pipefail
[[ ${TRACE_TESTS:-0} == 0 ]] || set -x
S=${DEPLOY_SCRIPT:?}; TEST_BASH=${TEST_BASH:-bash}; T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
mkdir "$T/bin"; LOG=$T/log; export LOG
for c in nix deploy-rs lab-update jj; do cat >"$T/bin/$c" <<'MOCK'
#!/usr/bin/env bash
echo "$(basename "$0") $*" >>"$LOG"
[[ $(basename "$0") != deploy-rs || ${*: -1} != *"${FAIL_HOST:-__never__}"* ]]
MOCK
chmod +x "$T/bin/$c"; done
cat >"$T/bin/uname" <<'MOCK'
#!/usr/bin/env bash
[[ ${1:-} == -n ]] || exit 2
echo "${MOCK_HOSTNAME:-client}"
MOCK
chmod +x "$T/bin/uname"
cat >"$T/inventory" <<'EOF'
poseidon	192.168.8.3	nixos
zeus	192.168.8.4	nixos
hades	192.168.8.2	nixos
eris	192.168.8.202	darwin
EOF
export PATH="$T/bin:$PATH" DEPLOY_FLAKE=/source DEPLOY_INVENTORY="$T/inventory" DEPLOY_RS="$T/bin/deploy-rs" LAB_UPDATE="$T/bin/lab-update"
run() { : >"$LOG"; "$TEST_BASH" "$S" "$@"; }
expect_failure() { if "$@"; then echo "expected failure: $*" >&2; return 1; fi; }
run --help; [[ ! -s $LOG ]]
expect_failure run unknown; [[ ! -s $LOG ]]
expect_failure run charon; [[ ! -s $LOG ]]
run hades; grep -Fq 'nix eval --json --no-write-lock-file /source#deploy.nodes.hades' "$LOG"; grep -Fq -- 'deploy-rs --skip-checks --remote-build /source#hades' "$LOG"; expect_failure grep -q interactive-sudo "$LOG"
for pair in '--dry-activate --dry-activate' '--test --test' '--boot --boot'; do read -r wrapper cli <<<"$pair"; run "$wrapper" hades; grep -Fq "deploy-rs $cli --skip-checks --remote-build /source#hades" "$LOG"; done
run --dry-activate eris; grep -Fq 'deploy-rs --dry-activate --skip-checks --remote-build /source#eris' "$LOG"
run --dry-activate lab; [[ $(grep -c '^deploy-rs ' "$LOG") == 4 ]]
for unsafe in test boot; do
  expect_failure run "--$unsafe" eris; [[ ! -s $LOG ]]
  expect_failure run "--$unsafe" lab; [[ ! -s $LOG ]]
done
export FAIL_HOST='#zeus'; expect_failure run lab; [[ $(grep -c '^deploy-rs ' "$LOG") == 2 ]]; unset FAIL_HOST
MOCK_HOSTNAME=hades; export MOCK_HOSTNAME; expect_failure run hades; [[ ! -s $LOG ]]; expect_failure run lab; [[ ! -s $LOG ]]; unset MOCK_HOSTNAME
run --assure hades; grep -Fq 'jj root' "$LOG"; grep -Fq 'lab-update --dry-run hades' "$LOG"; grep -Fq 'lab-update hades' "$LOG"
expect_failure run --assure eris
expect_failure run probe charon
echo 'deploy hermetic tests: ok'
