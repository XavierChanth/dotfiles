#!/bin/sh

if $(docker ps --all | grep xavierchanth:devenv | grep -q apollo); then
  docker start -ai apollo
else
  docker run -it --name apollo --hostname apollo \
    --mount type=bind,source="$HOME"/.ssh,target=/home/chant/.ssh \
    --mount type=bind,source="$HOME"/.atsign,target=/home/chant/.atsign \
    --mount type=bind,source="$HOME"/src,target=/home/chant/src \
    xavierchanth:devenv
fi
