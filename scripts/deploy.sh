terraform destroy -input=false -auto-approve
terraform init -input=false
terraform plan -input=false -out=tfplan
terraform apply -input=false -auto-approve tfplan
ssh -o StrictHostKeyChecking=no -i "~/.aws/GameKeyPair.pem" ubuntu@$(terraform output public_ip) "./initialize_game_api_instance.sh"