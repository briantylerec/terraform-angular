output "public_ips" {
  value = [aws_instance.node_instance.public_ip, aws_instance.mongo_instance.public_ip]
}

output "private_ips" {
  value = [aws_instance.node_instance.private_ip, aws_instance.mongo_instance.private_ip]
}

output "node_instance_id" {
  value = aws_instance.node_instance.id
}

output "mongo_instance_id" {
  value = aws_instance.mongo_instance.id
}

output "node_public_ip" {
  value = aws_instance.node_instance.public_ip
}

output "node_private_ip" {
  value = aws_instance.node_instance.private_ip
}

output "mongo_public_ip" {
  value = aws_instance.mongo_instance.public_ip
}

output "mongo_private_ip" {
  value = aws_instance.mongo_instance.private_ip
}
