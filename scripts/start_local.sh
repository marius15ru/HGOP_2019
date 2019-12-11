#!/bin/bash

set -euxo pipefail

docker build game_api -t marius15/hgop:day13
GIT_COMMIT=day13 docker-compose up