variable "availability_zones" {
  description = "Zonas de disponibilidad para el balanceador de carga"
  type = list(string)
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subnets"
  type        = list(string)
}

variable "node_security_id" {
  description = "ID del grupo de seguridad"
  type        = string
}

variable "mongo_security_id" {
  description = "ID del grupo de seguridad"
  type        = string
}

variable "node_instance_id" {
  description = "ID de la instancia node"
  type        = string
}