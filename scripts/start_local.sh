#!/bin/bash

set -euxo pipefail

docker build game_api -t {username}/{repo}:dev
GIT_COMMIT=dev docker-compose up