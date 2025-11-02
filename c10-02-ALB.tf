module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "10.1.0"

  name    = "${local.name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = [module.vpc.public_subnets[0], module.vpc.public_subnets[1] ]
  load_balancer_type = "application"
  create_security_group = false
  # Security Group
  security_groups = [module.loadbalancer_sg.security_group_id] 

  listeners = {
    mytg1 = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "mytg1"
      }
    }
  }

  target_groups = {
    mytg1 = {
      create_attachment = false 
      name_prefix                       = "mytg1-"
      protocol                          = "HTTP"
      protocol_version                  = "HTTP1"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_cross_zone_enabled = false
      port                              = 80
      tags                              = local.common_tags

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }
  tags = local.common_tags

}

resource "aws_lb_target_group_attachment" "ec2_attachments" {
  for_each         = {for i, instance_id in module.ec2_private : i => instance_id }
  target_group_arn = module.alb.target_groups["mytg1"].arn
  target_id        = each.value.id
  port             = 80
}


