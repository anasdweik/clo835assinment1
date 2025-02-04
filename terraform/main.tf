provider "aws" {
  region = "us-east-1"
}

# 🔹 Retrieve Existing Security Group (web-sg)
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["web-sg"]  # ✅ Using existing security group
  }
}

# 🔹 Deploy EC2 instance
resource "aws_instance" "web_server" {
  ami                    = "ami-0c614dee691cbbf37"  # ✅ Replace with your correct AMI ID
  instance_type          = "t2.micro"
  key_name               = "vockey"  # ✅ Use your actual key pair
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]  # ✅ Attach existing security group
  associate_public_ip_address = true  # ✅ Ensures the instance gets a public IP

  tags = {
    Name = "Employee-Database-App-Server"
  }
}

# 🔹 Use existing ECR repository for Web App
data "aws_ecr_repository" "web_app_repo" {
  name = "employee-database-app"
}

# 🔹 Use existing ECR repository for MySQL
data "aws_ecr_repository" "mysql_repo" {
  name = "mysql-database"
}

# 🔹 Output EC2 Public IP for GitHub Actions (No Manual Updates Needed)
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}
