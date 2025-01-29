resource "aws_security_group" "node_sg" {
  name_prefix = "node-sg-"
  description = "Security group for Node.js and Nginx"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Allow SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] 
  }
  

  tags = {
    Name = "node-sg"
  }
}

resource "aws_security_group" "mongo_sg" {
  name_prefix = "mongo-sg-"
  description = "Security group for MongoDB"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow MongoDB access from Node.js/Nginx instance"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    security_groups  = [aws_security_group.node_sg.id]
  }

  ingress {
    description      = "Allow SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "mongo-sg"
  }
}
