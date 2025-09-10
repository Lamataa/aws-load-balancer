# modules/network/variables.tf - Variáveis do módulo de Network

variable "vpc_cidr_block" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Map of public subnets with AZ as key and CIDR as value"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access (use your IP/32 for security)"
  type        = string
  default     = ""
}