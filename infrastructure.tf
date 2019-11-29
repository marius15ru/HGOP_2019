# Configuring the aws provider with proper credentials. For authentication the shared_credentials_file variable is used.
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-east-1"
}

# A resource describes one or more infrastructure objects

# Type: "aws_security_group", local name: "game_security_group", 
# This resource block creates a security group, gives it a name("GameSecurityGroup") and defines rules for ingress and egress filtering for the group.
resource "aws_security_group" "game_security_group" {
  name = "GameSecurityGroup"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Type: "aws_instance", local name: "game_server", 
# This resource bloc creates an EC2 instance of type "t2.micro" and associates it with the previously created security group above.
# Then copies a Bash script and a Docker compose file and sends it to the EC2 instance using ssh.
# Finally it sends a command to the EC2 instance that executes the Bash script(and the bash script in turn runs the Docker file), creating a new server.
resource "aws_instance" "game_server" {
  ami                    = "ami-0ac019f4fcb7cb7e6"
  instance_type          = "t2.micro"
  key_name               = "GameKeyPair"
  vpc_security_group_ids = [aws_security_group.game_security_group.id]
  tags = {
    Name = "GameServer"
  }

  # Copies "initialize_game_api_instance.sh" file to the EC2 instance using a ssh connection
  provisioner "file" {
    source      = "scripts/initialize_game_api_instance.sh"
    destination = "/home/ubuntu/initialize_game_api_instance.sh"

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.aws/GameKeyPair.pem")
    }
  }

  # Copies "docker-compose.yml" file to the EC2 instance using a ssh connection
  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.aws/GameKeyPair.pem")
    }
  }

  # This is used to run commands on the instance we just created.
  # Terraform does this by SSHing into the instance and then executing the commands.
  # Since it can take time for the SSH agent on machine to start up we let Terraform
  # handle the retry logic, it will try to connect to the agent until it is available
  # that way we know the instance is available through SSH after Terraform finishes.

  # Sends a command to the instance, commanding it to execute "initialize_game_api_instance.sh" script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/initialize_game_api_instance.sh",
    ]

    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.aws/GameKeyPair.pem")
    }
  }
}

# Output values are like the return values of a Terraform module
# Identifier: "public_ip"
# Returns the public_ip of the previously created sever("Game server")
output "public_ip" {
  value = aws_instance.game_server.public_ip
}