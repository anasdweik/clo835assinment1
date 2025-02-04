provider "aws" {
  region = "us-east-1"
}

# Create a Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow inbound traffic on port 8080 and SSH access"

  # Allow HTTP (8080) traffic
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (22) access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # ✅ Update this with the correct AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "your-key-pair"  # ✅ Replace with your actual key pair name
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "Employee-Database-App-Server"
  }
}

# Create an ECR Repository for Web App
resource "aws_ecr_repository" "web_app_repo" {
  name = "employee-database-app"
}

# Create an ECR Repository for MySQL
resource "aws_ecr_repository" "mysql_repo" {
  name = "mysql-database"
}
