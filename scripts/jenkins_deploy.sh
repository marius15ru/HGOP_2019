#!/bin/bash

set -euxo pipefail

GIT_COMMIT=$1 TEST=${2:-null}

ENV="production"

if [[ $TEST != "null" ]]; then
    ENV="${TEST}test"
fi

# We need to move some files around, because of the terraform state limitations.
mkdir -p /var/lib/jenkins/terraform/hgop/$ENV
mkdir -p /var/lib/jenkins/terraform/hgop/$ENV/scripts
rm -f /var/lib/jenkins/terraform/hgop/$ENV/scripts/initialize_game_api_instance.sh
cp scripts/initialize_game_api_instance.sh /var/lib/jenkins/terraform/hgop/$ENV/scripts/initialize_game_api_instance.sh
rm -f /var/lib/jenkins/terraform/hgop/$ENV/scripts/docker_compose_up.sh
cp scripts/docker_compose_up.sh /var/lib/jenkins/terraform/hgop/$ENV/scripts/docker_compose_up.sh
rm -f /var/lib/jenkins/terraform/hgop/$ENV/docker-compose.yml
cp docker-compose.yml /var/lib/jenkins/terraform/hgop/$ENV/docker-compose.yml

rm -f /var/lib/jenkins/terraform/hgop/$ENV/*.tf
cp ./*.tf /var/lib/jenkins/terraform/hgop/$ENV/

cd /var/lib/jenkins/terraform/hgop/$ENV
terraform init # In case terraform is not initialized.
terraform destroy -auto-approve -var environment=$ENV || exit 1
terraform apply -auto-approve -var environment=$ENV || exit 1

echo "Game API running at " + $(terraform output public_ip)
API_URL="http://$(terraform output public_ip):3000"

ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./initialize_game_api_instance.sh"
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./docker_compose_up.sh $GIT_COMMIT $API_URL"

if [[ $TEST != "null" ]]; then
    cd /var/lib/jenkins/workspace/Github_Pipeline_HGOP2019/game_api
    export API_URL
    sleep 30
    npm run test:$TEST
    cd /var/lib/jenkins/terraform/hgop/$ENV
    terraform destroy -auto-approve -var environment=$ENV || exit 1
fi

exit 0
