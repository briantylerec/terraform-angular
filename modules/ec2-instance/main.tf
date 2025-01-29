resource "aws_instance" "node_instance" {
  ami           = var.ami_node
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0]
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [var.node_security_group_id]

  tags = {
    Name = "Node-Nginx-Instance"
  }
}

resource "aws_instance" "mongo_instance" {
  ami           = var.ami_mongo
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[1]
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [var.mongo_security_group_id]

  tags = {
    Name = "MongoDB-Instance"
  }
}

# Creacion de aws key pair

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "packer-aws-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/packer-aws-key.pem"
}
