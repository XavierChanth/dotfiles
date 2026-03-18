#!/bin/sh
script_dir="$(dirname -- "$(readlink -f -- "$0")")"

docker_build() {
  docker build --tag $1 -f "$script_dir"/Dockerfile "$script_dir"
}

docker_build devenv:latest
