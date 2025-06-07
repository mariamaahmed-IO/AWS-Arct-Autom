output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnets" {
    value = module.vpc.public_subnets
  
}

output "private_subnet" {
    value = module.vpc.private_subnets
  
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "SSH into Bastion Host"
  value       = "ssh -i utc-key.pem ec2-user@${aws_instance.bastion.public_ip}"
}