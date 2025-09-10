# outputs.tf - Outputs do módulo root

# Network outputs
output "vpc_id" {
  description = "ID da VPC"
  value       = module.network.vpc_id
}

output "subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.network.subnet_ids
}

# Load Balancer outputs
output "load_balancer_dns_name" {
  description = "DNS name do Load Balancer"
  value       = module.loadbalancer.load_balancer_dns_name
}

output "load_balancer_url" {
  description = "URL completa do Load Balancer"
  value       = "http://${module.loadbalancer.load_balancer_dns_name}"
}

output "instance_ids" {
  description = "IDs das instâncias EC2"
  value       = module.loadbalancer.instance_ids
}

output "instance_public_ips" {
  description = "IPs públicos das instâncias EC2"
  value       = module.loadbalancer.instance_public_ips
}