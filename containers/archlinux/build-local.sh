#!/bin/bash

script_dir="$(dirname -- "$(readlink -f -- "$0")")"
docker build -f $script_dir/Dockerfile.local -t xavierchanth:arch $script_dir/../.. 2>&1 | tee build.log
