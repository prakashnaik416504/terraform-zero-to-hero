
resource "aws_iam_role" "ec2_s3_role" {
  name = "ubuntu_ec2_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ubuntu_ec2_s3_profile"
  role = aws_iam_role.ec2_s3_role.name
}


resource "aws_security_group" "ec2_sg" {
  name        = "ubuntu_ec2_sg"
  description = "Allow SSH"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "ubuntu_s3_mounter" {
  ami                  = var.ami_id # Ubuntu 22.04 LTS (update if needed)
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups      = [aws_security_group.ec2_sg.name]
  tags = {
    Name = "Ubuntu-S3-Mounter"
  }

user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y s3fs
snap install aws-cli --classic

# Create mount point
mkdir -p /mnt/s3bucket

# Mount S3 bucket using IAM role and correct endpoint
echo "s3fs#${var.bucket_var} /mnt/s3bucket fuse _netdev,iam_role=auto,allow_other,use_path_request_style,url=https://s3-ap-south-1.amazonaws.com,endpoint=ap-south-1 0 0" >> /etc/fstab

# Mount immediately
mount -a
EOF

}
