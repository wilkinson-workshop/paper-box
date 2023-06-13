#!/bin/sh

wget https://download.docker.com/mac/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz

# Extract.
tar -xzvf docker-${DOCKER_VERSION}.tgz

# Clear the extended attributes to allow it to
# run.
find docker -type f | xargs xattr -c
