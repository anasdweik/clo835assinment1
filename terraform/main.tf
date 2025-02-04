provider "aws" {
  region = "us-east-1"
}

# 🔹 Use existing Security Group (web-sg) instead of creating a new one
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["web-sg"]  # ✅ Use existing security group
  }
}

# 🔹 Deploy EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c614dee691cbbf37"  # ✅ Correct AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "vockey"  # ✅ Your EC2 key pair
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]  # ✅ Attach existing Security Group

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
