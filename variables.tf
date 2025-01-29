variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  default     = "us-west-2"
}

variable "ami_node" {
  description = "AMI ID for the Node.js and Nginx instance"
  type        = string
}

variable "ami_mongo" {
  description = "AMI ID for the MongoDB instance"
  type        = string
}


# variable "public_subnet_id" {
#     description = ""
#     type        = string
# }

# variable "private_subnet_id" {
#     description = ""
#     type        = string
# }

# variable "security_groups_id" {
#     description = ""
#     type        = string
# }

# variable "node_security_group_id" {
#   description = ""
#     type        = string
# }

# variable "mongo_security_group_id" {
#   description = ""
#     type        = string
# }