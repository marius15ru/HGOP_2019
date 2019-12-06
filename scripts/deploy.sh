terraform destroy -input=false -auto-approve
terraform apply -input=false -auto-approve
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./initialize_game_api_instance.sh"