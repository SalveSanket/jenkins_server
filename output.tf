output "public_ip" {
  description = "The public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.public_ip
}

output "public_dns" {
  description = "The public DNS name of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.public_dns
}

# Output the default EC2 username (based on AMI type)
output "ec2_user" {
  description = "Default EC2 username based on AMI name"
  value = (
    can(regex("ubuntu", data.aws_ami.Amazon_AMI.name)) ? "ubuntu" :
    can(regex("amzn", data.aws_ami.Amazon_AMI.name)) ? "ec2-user" :
    can(regex("debian", data.aws_ami.Amazon_AMI.name)) ? "admin" :
    can(regex("centos", data.aws_ami.Amazon_AMI.name)) ? "centos" :
    "ec2-user"
  )
}

# Output SSH connection string
output "ssh_connection" {
  description = "SSH command to connect to the EC2 instance"
  value = (
    can(regex("ubuntu", data.aws_ami.Amazon_AMI.name)) ?
    "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.jenkins_server.public_ip}" :
    can(regex("amzn", data.aws_ami.Amazon_AMI.name)) ?
    "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.jenkins_server.public_ip}" :
    can(regex("debian", data.aws_ami.Amazon_AMI.name)) ?
    "ssh -i ~/.ssh/id_rsa admin@${aws_instance.jenkins_server.public_ip}" :
    can(regex("centos", data.aws_ami.Amazon_AMI.name)) ?
    "ssh -i ~/.ssh/id_rsa centos@${aws_instance.jenkins_server.public_ip}" :
    "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.jenkins_server.public_ip}"
  )
}

output "jenkins_url" {
  description = "Jenkins UI URL"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}