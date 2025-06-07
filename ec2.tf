# --- Bastion Host EC2 Instance ---
resource "aws_instance" "bastion" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  key_name               = "utc-key"
  vpc_security_group_ids = [module.bastion_sg.security_group_id]

  associate_public_ip_address = true
  tags = {
    Name = "bastion-host"
    team = "config management"
    env  = "dev"
  }
}


# --- App Server EC2 Instances using count 6total, 2 per AZ)---
locals {
  private_subnets             = module.vpc.private_subnets
  app_server_count_per_subnet = 1
}

resource "aws_instance" "app_server" {
  count                  = length(local.private_subnets) - 1 # 6 subnets → 6 instances (1 per subnet)
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = local.private_subnets[count.index]
  key_name               = aws_key_pair.utc_key.key_name
  vpc_security_group_ids = [module.app_sg.security_group_id]
  user_data              = filebase64("userdata.sh")

  tags = {
    Name = "appserver-${floor(count.index / local.app_server_count_per_subnet)}-${count.index % local.app_server_count_per_subnet}"
    env  = "dev"
    team = "config management"
  }
}
