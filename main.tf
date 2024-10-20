# Sağlayıcı Ayarları
provider "aws" {
  region  = "us-east-1"
  version = "~> 5.45.0"
}

# Değişkenler


# EC2 Instance
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = var.ins-type
  key_name      = var.key
  user_data = file("userdata.sh")

  iam_instance_profile = "jenkins-project-profile-techpro"

  tags = {
    Name = "jenkins_project"
  }

  security_groups = [aws_security_group.jenkins_sec_group.name]

  associate_public_ip_address = true
}

resource "aws_security_group" "jenkins_sec_group" {
  name        = "project-jenkins-sec-gr"
  description = "Jenkins project-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Web app on port 5000"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Web interface on port 3000"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "PostgreSQL access on port 5432"
  }

  # Giden Trafik Kuralları (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

output "node_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
  description = "The public IP of the Jenkins EC2 instance"
}

output "instance_id" {
  value = aws_instance.jenkins_instance.id
}
