# modules/loadbalancer/outputs.tf - Outputs do módulo de Load Balancer

output "load_balancer_arn" {
  description = "ARN do Application Load Balancer"
  value       = aws_lb.load_balancer.arn
}

output "load_balancer_dns_name" {
  description = "DNS name do Load Balancer"
  value       = aws_lb.load_balancer.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID do Load Balancer"
  value       = aws_lb.load_balancer.zone_id
}

output "target_group_arn" {
  description = "ARN do Target Group"
  value       = aws_lb_target_group.target_group.arn
}

output "instance_ids" {
  description = "IDs das instâncias EC2 criadas"
  value       = aws_instance.instances[*].id
}

output "instance_public_ips" {
  description = "IPs públicos das instâncias EC2"
  value       = aws_instance.instances[*].public_ip
}

output "instance_private_ips" {
  description = "IPs privados das instâncias EC2"
  value       = aws_instance.instances[*].private_ip
}