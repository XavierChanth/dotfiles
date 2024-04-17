#!/bin/sh
script_dir="$(dirname -- "$(readlink -f -- "$0")")"

docker_build() {
  docker build --tag devenv:latest -f "$script_dir"/Dockerfile "$script_dir"
  docker image tag devenv:latest xavierchanth/devenv:latest
}

docker_build
(
  export DOCKER_DEFAULT_PLATFORM=linux/amd64
  docker_build
)
