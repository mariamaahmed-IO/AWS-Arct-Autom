module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "project-1-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true


  public_subnet_tags = {
    Tier = "public_subnet"

  }

  private_subnet_tags = {
    Tier = "private_subnet"
  }
  tags = {
    Name = "project-1-vpc"
    team = "config management"
    env  = "dev"
  }
}
  


#   # to creat nat gateway 
#   #module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "project-1-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = false
#   enable_dns_hostnames = true

#   tags = {
#     Name = "project-1-vpc"
#     team = "config management"
#     env  = "dev"
#   }
# }

# # NAT Gateways
# resource "aws_eip" "nat_1a" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat_1a" {
#   allocation_id = aws_eip.nat_1a.id
#   subnet_id     = module.vpc.public_subnets[0]
#   depends_on    = [module.vpc]
#   tags = {
#     Name = "nat-1a"
#   }
# }

# resource "aws_eip" "nat_1b" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat_1b" {
#   allocation_id = aws_eip.nat_1b.id
#   subnet_id     = module.vpc.public_subnets[1]
#   depends_on    = [module.vpc]
#   tags = {
#     Name = "nat-1b"
#   }
# }

# # Route tables and associations
# resource "aws_route_table" "private_1a" {
#   vpc_id = module.vpc.vpc_id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_1a.id
#   }
#   tags = {
#     Name = "private-1a-rt"
#   }
# }

# resource "aws_route_table" "private_1b" {
#   vpc_id = module.vpc.vpc_id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_1b.id
#   }
#   tags = {
#     Name = "private-1b-rt"
#   }
# }

# resource "aws_route_table" "private_1c" {
#   vpc_id = module.vpc.vpc_id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_1a.id # or nat_1b
#   }
#   tags = {
#     Name = "private-1c-rt"
#   }
# }

# # Subnet associations (you must know which private subnet maps to which AZ)
# resource "aws_route_table_association" "private_1a_assoc" {
#   subnet_id      = module.vpc.private_subnets[0]
#   route_table_id = aws_route_table.private_1a.id
# }

# resource "aws_route_table_association" "private_1b_assoc" {
#   subnet_id      = module.vpc.private_subnets[1]
#   route_table_id = aws_route_table.private_1b.id
# }

# resource "aws_route_table_association" "private_1c_assoc" {
#   subnet_id      = module.vpc.private_subnets[2]
#   route_table_id = aws_route_table.private_1c.id
# }
