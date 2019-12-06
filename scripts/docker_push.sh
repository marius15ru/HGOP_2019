#!/bin/bash

GIT_COMMIT=$1

docker push https://hub.docker.com/repository/docker/marius15/hgop:$GIT_COMMIT

set -o errexit