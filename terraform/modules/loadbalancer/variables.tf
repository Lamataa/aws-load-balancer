# modules/loadbalancer/variables.tf - Variáveis do módulo de Load Balancer

variable "vpc_id" {
  description = "ID da VPC onde os recursos serão criados"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets para o load balancer"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID do security group para os recursos"
  type        = string
}

variable "lb_name" {
  description = "Nome do Application Load Balancer"
  type        = string
  default     = "app-lb"
}

variable "target_group_name" {
  description = "Nome do Target Group"
  type        = string
  default     = "app-tg"
}

variable "ami_id" {
  description = "ID da AMI para as instâncias EC2"
  type        = string
  default     = "ami-00a929b66ed6e0de6"
}

variable "instance_type" {
  description = "Tipo das instâncias EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nome da chave SSH para as instâncias"
  type        = string
  default     = "vockey"
}

variable "instance_name_prefix" {
  description = "Prefixo para o nome das instâncias"
  type        = string
  default     = "instance"
}