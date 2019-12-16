#!/bin/bash

set -euxo pipefail

export GIT_COMMIT=$1
export API_URL=$2
docker-compose down
docker-compose up -d
