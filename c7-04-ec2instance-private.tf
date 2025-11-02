module "ec2_private" {
  depends_on = [ module.vpc ] 
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.4"
  create_security_group = false
  name                   = "${var.environment}-vm"
  ami                    = data.aws_ami.aws_amiec2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  user_data = file("${path.module}/app1-install.sh")
  tags = local.common_tags
  vpc_security_group_ids = [module.private_sg.security_group_id]
  create_spot_instance = false
  for_each = toset(["0", "1"])
  subnet_id =  element(module.vpc.private_subnets, tonumber(each.key))     #element function get index and value from list element(["list1","list2"],index)  , index act in int and iterate each of list one by one
                                                                           #tonumber function convert string to int

#  other approach using for_each with map
#  for_each = { for idx, subnet_id in module.vpc.private_subnets : idx => subnet_id }
#  subnet_id     = each.value
}

