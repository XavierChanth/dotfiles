#!/bin/zsh
# commands.zsh contains slightly more complex / use-case specific things than alias.zsh

# rollup a bunch of PRs into a single PR, useful for dealing with several dependabot PRs all at once
rollup() {
  if [ $# -ne 2 ]; then
    echo "Usage rollup <BASE_PR> <LAST_PR>"
    exit 1
  fi
  BASE_PR=$1
  LAST_PR=$2
  git pull
  gh pr checkout "$BASE_PR"
  for ((i = (($BASE_PR + 1)); i <= $LAST_PR; i++)); do
    IS_CLOSED=$(gh pr view "$i" --json closed -q .closed || false)
    if [ -n "$IS_CLOSED" ] && [ ! "$IS_CLOSED" ]; then
      PR_BRANCH=$(gh pr view "$i" --json headRefName -q .headRefName)
      git merge origin/"$PR_BRANCH" -m "build(deps): Rollup merge branch for #${i} ${PR_BRANCH}"
    fi
  done
  git push
}

_nb_ensure_notebook() {
  nb notebooks show "$1" --name >/dev/null 2>&1 || nb notebooks add "$1"
}

# Capture a note in the shared inbox. With no arguments, open the editor.
nbi() {
  _nb_ensure_notebook inbox || return

  if (( $# )); then
    nb inbox:add "$*"
  else
    nb inbox:add
  fi
}

# Capture a todo in the shared inbox.
nbt() {
  if (( ! $# )); then
    echo "Usage: nbt <todo>" >&2
    return 1
  fi

  _nb_ensure_notebook inbox || return
  nb todo add inbox: "$*"
}

# Browse the notebook matching the current project root.
nbp() {
  local project_root project_name

  if command -v jj >/dev/null 2>&1 && project_root="$(jj root 2>/dev/null)"; then
    :
  elif project_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    :
  else
    project_root="$PWD"
  fi

  project_name="${project_root:t}"

  _nb_ensure_notebook "$project_name" || return
  nb browse "${project_name}:" --gui
}
