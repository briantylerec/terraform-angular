output "node_security_group_id" {
  value = aws_security_group.node_sg.id
}

output "mongo_security_group_id" {
  value = aws_security_group.mongo_sg.id
}