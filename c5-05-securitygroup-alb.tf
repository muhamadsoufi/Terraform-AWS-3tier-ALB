# AWS alb Security Group Terraform Module
# Security Group for Load Balancer
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name = "loadbalancer-sg"
  description = "Security Group with HTTP internet, egress ports are all world open"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"] # HTTP open to the world
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = local.common_tags
}

