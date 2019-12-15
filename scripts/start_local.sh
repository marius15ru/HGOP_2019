#!/bin/bash

set -euxo pipefail

docker build game_api -t marius15/game_api:dev
(cd game_client && npm run build)
docker build game_client -t marius15/game_client:dev

API_URL=http://localhost GIT_COMMIT=dev docker-compose up
