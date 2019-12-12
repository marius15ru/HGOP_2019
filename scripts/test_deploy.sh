#!/bin/bash

set -euxo pipefail

GIT_COMMIT=$1 TEST=$2
TEST_ENV="${TEST}test"

sh "./jenkins_deploy.sh ${GIT_COMMIT} ${TEST_ENV}"

cd /var/lib/jenkins/workspace/Github_Pipeline_HGOP2019/game_api
API_URL=$(terraform output public_dns):3000 npm run test:$TEST
cd /var/lib/jenkins/terraform/hgop/$TEST_ENV
terraform destroy -auto-approve -var environment=$TEST_ENV || exit 1

exit 0