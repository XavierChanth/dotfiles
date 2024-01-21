#!/bin/zsh

# git
alias glog='git log --oneline --decorate --graph'
alias gloga='glog --all'
clone() {
  REPO=$1
  shift;

  if [[ $REPO =~ ^(git@github\.com:.*|https:\/\/github\.com\/.*)$ ]]; then
    prefix=""
  else
    prefix="git@github.com:"
  fi

  git clone "$prefix$REPO" "$@"
}

# vim
alias vi='nvim'
alias vim='nvim'

# dart/flutter
alias pub='dart pub'
alias melos='dart run melos'

# devops
alias dump_cards='with_dc_pat ~/src/ac/dump_cards/dump_cards.py'
alias vsce='with_vsce_pat vsce'

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

# atsign
atDirectory() {
  head -n 1 < <(openssl s_client -connect root.atsign.org:64 -quiet -verify_quiet < <(echo "$1"; sleep 1; echo "@exit") 2>/dev/null)
}

atServer() {
  fqdn=$(atDirectory "$1" | tr -d '\r\n\t ')
  openssl s_client -connect "${fqdn:1}"
}

pkam() {
  at_pkam -p "$HOME/.atsign/keys/$1_key.atKeys" -r "$2"
}

# sshnoports
alias getsshnp="bash -c \"\$(curl -fsSL https://getsshnp.noports.com)\" --"
alias getsshnpd="bash -c \"\$(curl -fsSL https://getsshnpd.noports.com)\" --"

