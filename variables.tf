# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

# Security Group
variable "ssh_ingress_cidr" {
  description = "CIDR block allowed to access via SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "jenkins_ingress_cidr" {
  description = "CIDR block allowed to access Jenkins"
  type        = string
  default     = "0.0.0.0/0"
}

# Key Pair
variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "mac-ssh-key"
}

variable "public_key_path" {
  description = "Path to the public key used for EC2 access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# EC2 Instance
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}