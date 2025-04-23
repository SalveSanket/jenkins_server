# VPC configuration
vpc_cidr = "10.0.0.0/16"

# Public subnet configuration
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "us-east-1a"

# Security group ingress rules
ssh_ingress_cidr     = "0.0.0.0/0" # Use your IP in production
jenkins_ingress_cidr = "0.0.0.0/0"

# Key pair
key_pair_name   = "mac-ssh-key"
public_key_path = "~/.ssh/id_rsa.pub"

# EC2 instance
instance_type = "t3.medium"