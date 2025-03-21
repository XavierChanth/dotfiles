#!/usr/bin/env bash

rm repos_to_mirror.txt
./export-new-repos.sh

if [ -s repos_to_mirror.txt ]; then
  ./mirror-repos.sh repos_to_mirror.txt
fi
