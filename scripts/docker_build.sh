#!/bin/bash

set -euxo pipefail

GIT_COMMIT=$1

docker build -t marius15/game_api:$GIT_COMMIT game_api/
docker build -t marius15/game_client:$GIT_COMMIT game_client/

exit 0