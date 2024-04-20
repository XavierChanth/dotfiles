#!/bin/sh
script_dir="$(dirname -- "$(readlink -f -- "$0")")"

docker_build() {
  docker build --tag $1 -f "$script_dir"/Dockerfile "$script_dir"
}

docker_build devenv-arm64:latest
(
  DOCKER_DEFAULT_PLATFORM=linux/amd64
  docker_build devenv-x64:latest
)
