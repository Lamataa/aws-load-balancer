# modules/network/outputs.tf - Outputs do módulo de Network

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.vpc.id
}

output "subnet_ids" {
  description = "Lista de IDs das subnets públicas criadas"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "subnet_map" {
  description = "Map de subnets por AZ"
  value       = { for az, subnet in aws_subnet.public_subnets : az => subnet.id }
}

output "security_group_id" {
  description = "ID do security group criado"
  value       = aws_security_group.vpc_sg_public.id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "vpc_cidr_block" {
  description = "CIDR block da VPC"
  value       = aws_vpc.vpc.cidr_block
}