# modules/loadbalancer/main.tf - Módulo de Load Balancer

# Template file para user data
data "template_file" "user_data" {
  template = file("${path.root}/scripts/user_data.sh")
}

# EC2 INSTANCES
resource "aws_instance" "instances" {
  count = length(var.subnet_ids)
  
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_ids[count.index]
  vpc_security_group_ids  = [var.security_group_id]
  user_data_base64        = base64encode(data.template_file.user_data.rendered)
  key_name                = var.key_name
  
  # Configurações de segurança do Checkov
  monitoring    = true
  ebs_optimized = true
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  
  tags = {
    Name = "${var.instance_name_prefix}-${count.index + 1}"
  }
}

# LOAD BALANCER TARGET GROUP
resource "aws_lb_target_group" "target_group" {
  name     = var.target_group_name
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
  
  tags = {
    Name = var.target_group_name
  }
}

# TARGET GROUP ATTACHMENTS
resource "aws_lb_target_group_attachment" "target_attachments" {
  count = length(aws_instance.instances)
  
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.instances[count.index].id
  port             = 80
}

# APPLICATION LOAD BALANCER
resource "aws_lb" "load_balancer" {
  name               = var.lb_name
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]
  
  enable_deletion_protection = false
  
  tags = {
    Name = var.lb_name
  }
}

# LOAD BALANCER LISTENER
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  
  tags = {
    Name = "${var.lb_name}-listener"
  }
}