#!/bin/zsh
# commands.zsh contains slightly more complex / use-case specific things than alias.zsh

# requires secrets.zsh
alias dump_cards='with_dc_pat ~/src/ac/dump_cards/dump_cards.py'
alias vsce='with_vsce_pat vsce'

# rollup a bunch of PRs into a single PR, useful for dealing with several dependabot PRs all at once
rollup() {
  if [ $# -ne 2 ] ; then
    echo "Usage rollup <BASE_PR> <LAST_PR>"
    exit 1
  fi
  BASE_PR=$1
  LAST_PR=$2
  git pull
  gh pr checkout "$BASE_PR"
  for (( i=(($BASE_PR + 1)); i<=$LAST_PR; i++ ));
  do
    IS_CLOSED=$(gh pr view "$i" --json closed -q .closed || false);
    if [ -n "$IS_CLOSED" ] && [ ! "$IS_CLOSED" ]; then
      PR_BRANCH=$(gh pr view "$i" --json headRefName -q .headRefName);
      git merge origin/"$PR_BRANCH" -m "build(deps): Rollup merge branch for #${i} ${PR_BRANCH}";
    fi
  done
  git push
}
