module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "alb-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow inbound from everywhere to 80 and 443 ports (HTTP and HTTPS protocols)"

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    env  = "dev"
    team = "config management"
  }
}

module "bastion_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.0"
  name        = "bastion-sg"
  vpc_id      = module.vpc.vpc_id
  description = "SSH from my IP"

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "${chomp(data.http.my_ip.response_body)}/32"
    }
  ]

  egress_rules = ["all-all"]
}

module "app_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.0"
  name        = "app-sg"
  vpc_id      = module.vpc.vpc_id
  description = "App servers allow HTTP from ALB and SSH from bastion"

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

module "db_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.0"
  name        = "db-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow MySQL from app servers"

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}
