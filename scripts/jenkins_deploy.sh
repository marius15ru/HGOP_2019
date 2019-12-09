#!/bin/bash

GIT_COMMIT=$1

# We need to move some files around, because of the terraform state limitations.
mkdir -p /var/lib/jenkins/terraform/hgop/production
mkdir -p /var/lib/jenkins/terraform/hgop/production/scripts
rm -f /var/lib/jenkins/terraform/hgop/production/scripts/initialize_game_api_instance.sh
cp scripts/initialize_game_api_instance.sh /var/lib/jenkins/terraform/hgop/production/scripts/initialize_game_api_instance.sh
rm -f /var/lib/jenkins/terraform/hgop/production/scripts/docker_compose_up.sh
cp scripts/docker_compose_up.sh /var/lib/jenkins/terraform/hgop/production/scripts/docker_compose_up.sh  && echo -e "Cp Sucess" || echo -e "Cp Fail"
rm -f /var/lib/jenkins/terraform/hgop/production/docker-compose.yml
cp docker-compose.yml /var/lib/jenkins/terraform/hgop/production/docker-compose.yml

echo $(cd /var/lib/jenkins/terraform/hgop/production && ls)
echo $(cd /var/lib/jenkins/terraform/hgop/production/scripts && ls)

rm -f /var/lib/jenkins/terraform/hgop/production/*.tf
cp *.tf /var/lib/jenkins/terraform/hgop/production

cd /var/lib/jenkins/terraform/hgop/production
echo $(ls)
echo $(cd scripts && ls)
terraform init # In case terraform is not initialized.
terraform destroy -auto-approve
terraform apply -auto-approve

echo "Game API running at " + $(terraform output public_ip)

echo $(ls)
echo $(cd scripts && ls)

ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./initialize_game_api_instance.sh"
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) echo $(ls)
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) echo $(cd scripts && ls)
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) echo $(pwd)
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./docker_compose_up.sh $GIT_COMMIT"

echo $(ls)
echo $(cd scripts && ls)

set -o errexit

exit 0
