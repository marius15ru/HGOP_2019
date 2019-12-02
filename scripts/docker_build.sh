#!/bin/bash

GIT_COMMIT=$1

docker build -t marius15/hgop:$GIT_COMMIT item_repository/

set -o errexit
