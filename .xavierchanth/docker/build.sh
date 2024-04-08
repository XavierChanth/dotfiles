#!/bin/sh

docker build --tag xavierchanth:ubuntu -f Dockerfile.ubuntu .
docker build --tag xavierchanth:devenv -f Dockerfile.devenv .
