#!/bin/bash

set -euxo pipefail

GIT_COMMIT=$1

docker push marius15/game_api:$GIT_COMMIT
docker push marius15/game_client:$GIT_COMMIT

exit 0