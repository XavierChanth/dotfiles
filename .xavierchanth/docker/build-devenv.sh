#!/bin/sh
tag=$1
docker build --tag xavierchanth/devenv:$tag -f Dockerfile.devenv .
docker image tag xavierchanth/devenv:$1 xavierchanth/devenv:latest
