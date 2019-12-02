#!/bin/bash

GIT_COMMIT=$1

docker push marius15/hgop:$GIT_COMMIT

set -o errexit