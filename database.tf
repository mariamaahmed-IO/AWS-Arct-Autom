## RDS (MySQL) Setup
resource "aws_db_subnet_group" "rds" {
  name       = "utc-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "utc-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier        = "utc-dev-database"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "utcuser"
  password          = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [module.db_sg.security_group_id]
  skip_final_snapshot = true
  multi_az = false

  tags = {
    Name = "utc-dev-database"
    team = "config management"
    env  = "dev"
  }
}

