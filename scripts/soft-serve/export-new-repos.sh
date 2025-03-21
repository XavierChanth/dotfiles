#!/usr/bin/env bash

# creates a mirror for all repos visible to you in the orgs list
# skips ones that have already been seen using a local cache
# see sync-new-repos.sh to run this properly
orgs="xavierchanth atsign-foundation atsign-company"

list_soft_repos() {
  for repo in $(ssh localhost -p 222 repo list); do
    echo "git@github.com:$repo.git"
  done
}

list_gh_repos() {
  for org in $orgs; do
    gh repo list -L 200 --json "sshUrl" -q ".[].sshUrl" $org
  done
}

list_gh_repos | sort >gh_repos.txt
list_soft_repos | sort >soft_repos.txt

comm -23 gh_repos.txt soft_repos.txt >repos_to_mirror.txt
