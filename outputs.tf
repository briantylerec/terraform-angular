output "public_ips" {
  value = module.ec2_instance.public_ips
}

output "private_ips" {
  value = module.ec2_instance.private_ips
}

output "load_balancer_dns" {
  value = module.load_balancer.dns_name
}

output "nat_gateway_public_ip" {
  value = module.network.nat_gateway_eip_public_ip
}