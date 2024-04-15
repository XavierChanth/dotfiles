#!/bin/sh
docker_build() {
  docker build --tag devenv:latest -f Dockerfile.devenv .
  docker image tag devenv:latest xavierchanth/devenv:latest
}

docker_build
(
  export DOCKER_DEFAULT_PLATFORM=linux/amd64
  docker_build
)
