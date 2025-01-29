variable "ami_mongo" {
  description = "AMI ID for MongoDB instance"
  type        = string
}

variable "ami_node" {
  description = "AMI ID for Node instance"
  type        = string
}

variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_ids" {
    description = ""
    type        = list(string)
}

variable "node_security_group_id" {
  description = ""
  type        = string
}

variable "mongo_security_group_id" {
  description = ""
  type        = string
}

variable "vpc_id" {
  description = ""
  type        = string
}