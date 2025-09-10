# main.tf - Arquivo principal que chama os módulos

# Módulo de Network
module "network" {
  source = "./modules/network"
  
  vpc_cidr_block = "10.0.0.0/16"
  
  public_subnets = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

# Módulo de Load Balancer
module "loadbalancer" {
  source = "./modules/loadbalancer"
  
  # Passando outputs do módulo network como inputs
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.subnet_ids
  security_group_id = module.network.security_group_id
  
  # Configurações do Load Balancer
  lb_name           = "ec2-lb"
  target_group_name = "ec2-lb-tg"
  
  # Configurações das instâncias EC2
  ami_id        = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"
  key_name      = "vockey"
}