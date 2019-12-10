#!/bin/bash

set -euxo pipefail

GIT_COMMIT=$1

docker build -t marius15/hgop:$GIT_COMMIT game_api/

exit 0