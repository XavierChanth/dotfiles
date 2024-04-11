#!/bin/sh
name="$1"

if [ -z "$name" ]; then
  echo "name is empty"
  exit 1
fi

if $(docker ps --all | grep xavierchanth/devenv | grep -q "$name"); then
  echo "starting $name"
  docker start -ai "$name"
else
  echo "creating new $name container"
  docker run -d --name "$name" --hostname "$name" \
    --mount type=bind,source="$HOME"/.ssh,target=/home/chant/.ssh \
    --mount type=bind,source="$HOME"/.atsign,target=/home/chant/.atsign \
    --mount type=bind,source="$HOME"/src,target=/home/chant/src \
    xavierchanth/devenv:latest
fi
