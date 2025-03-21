#!/usr/bin/env bash

# creates a mirror for a list of repos on github
# see sync-new-repos.sh to run this properly

soft() {
  ssh localhost -p 222 $@
}

mirror_repo() {
  repo="$1"
  name="$(echo $repo | sed -E -e 's|git@github.com:(.*)\.git|\1|')"
  echo "mirroring $name: $repo"
  soft repo import -m -n $name $name $repo &&
    echo "imported $repo"
  sleep 2
}

mirror_file() {
  file="$1"
  repos="$(cat $file)"
  for repo in $repos; do
    mirror_repo $repo
  done
}

for file in $@; do
  mirror_file $file
done
