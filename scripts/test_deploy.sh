#!/bin/bash

set -euxo pipefail

GIT_COMMIT=$1 TEST=$2
TEST_ENV="${TEST}test"

sh "./jenkins_deploy.sh ${GIT_COMMIT} ${TEST}"

cd /var/lib/jenkins/workspace/Github_Pipeline_HGOP2019/game_api
API_URL=$(terraform output public_dns):3000 npm run test:$TEST_KIND
cd /var/lib/jenkins/terraform/hgop/$ENV
terraform destroy -auto-approve -var environment=$ENV || exit 1

ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./initialize_game_api_instance.sh"
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./docker_compose_up.sh $GIT_COMMIT"

exit 0