provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "tf-iams3-bucket" {
  bucket = var.s3-bucket
}

# 1. Policy implementation json string inline.
#
# resource "aws_iam_policy" "inline" {
#   name   = "tf-inline"
#   policy = <<EOF
#   {
#   "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": [
#           "s3:ListBucket"
#         ],
#         "Effect": "Allow",
#         "Resource": "${aws_s3_bucket.tf-iams3-bucket.arn}"
#       },
#       {
#       "Action": [
#         "s3:GetObject",
#         "s3:PutObject"
#       ],
#       "Effect": "Allow",
#       "Resource": "${aws_s3_bucket.tf-iams3-bucket.arn}/*"
#       }
#     ]
#     }
#   EOF
# } 


# 2. Policy implementation using terraform jsonencode(). 
# resource "aws_iam_policy" "jsonencode" {
#   name = "tf-jsonencode"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:ListBucket"
#         ]
#         Resource = [
#           aws_s3_bucket.tf-iams3-bucket.arn
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject"
#         ]
#         Resource = [
#           "${aws_s3_bucket.tf-iams3-bucket.arn}/*"
#         ]
#       }
#     ]

#   })
# }

# 3. Policy Implemention using data resource
resource "aws_iam_policy" "policydocument" {
  name   = "tf-policydocument"
  policy = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.tf-iams3-bucket.arn
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.tf-iams3-bucket.arn}/*"
    ]
  }
}

# Disable public access blocks for the bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tf-iams3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure object ownership to allow ACLs to be effective
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.tf-iams3-bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# Set the bucket ACL to public-read
resource "aws_s3_bucket_acl" "public_read_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example
  ]
  bucket = aws_s3_bucket.tf-iams3-bucket.id
  acl    = "public-read"
}

# Setting Object-Level ACLs
resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.tf-iams3-bucket.id
  key    = "test/test.html" # Object name in S3
  source = "modules/s3_mount/test.html"      # Local file to upload
  acl    = "public-read"    # Grants public read access
  depends_on = [
    aws_s3_bucket_acl.public_read_acl,
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example
  ]
}


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

# Need to delete later below
# resource "aws_security_group" "ec2_sg" {
#   name        = "ubuntu_ec2_sg"
#   description = "Allow SSH"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


resource "aws_instance" "ubuntu_s3_mounter" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  # security_groups      = [var.sg_name]
  vpc_security_group_ids = [var.sg_id]
  subnet_id = var.subnet_id
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
echo "s3fs#${aws_s3_bucket.tf-iams3-bucket.bucket} /mnt/s3bucket fuse _netdev,iam_role=auto,allow_other,use_path_request_style,url=https://s3-ap-south-1.amazonaws.com,endpoint=ap-south-1 0 0" >> /etc/fstab

# Mount immediately
mount -a
EOF

}
