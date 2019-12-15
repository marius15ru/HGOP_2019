#!/bin/bash

set -euxo pipefail

GIT_COMMIT=$1

docker push marius15/game_api:$GIT_COMMIT

exit 0