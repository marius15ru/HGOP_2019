#!/bin/bash

set -euxo pipefail


GIT_COMMIT=$1 ENV=${2:-$production}

if [[ $ENV != 'production' ]]; then
    TEST_KIND=$ENV
    ENV="${ENV}test"
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

if [[ $ENV != 'production' ]]; then
    cd game_api/
    sh "API_URL=" + $(terraform output public_ip) + ":3000 npm run test:capacity"
    cd /var/lib/jenkins/terraform/hgop/$ENV
    sh "terraform destroy -auto-approve -var environment=$ENV || exit 1"
fi

echo "Game API running at " + $(terraform output public_ip)

ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./initialize_game_api_instance.sh"
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./docker_compose_up.sh $GIT_COMMIT"

exit 0