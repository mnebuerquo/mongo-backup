#!/bin/sh

set -e

IMAGE_NAME=backup-dev
WORKDIR=/app

docker build -f Dockerfile.dev -t ${IMAGE_NAME} .
docker run -it \
	-w "${WORKDIR}" \
	-v "$(pwd):${WORKDIR}" \
	${IMAGE_NAME} \
	$@
