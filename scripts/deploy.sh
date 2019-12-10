#!/bin/bash

set -euxo pipefail

terraform destroy -auto-approve
terraform apply -auto-approve
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./initialize_game_api_instance.sh"
curl $(terraform output public_ip):3000/status

exit 0