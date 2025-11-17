variable "aws_region" {
  description = "AWS Region name"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "IP range for the VPC"
  default     = "10.0.0.0/16"
}

variable "s3-bucket" {
  description = "AWS S3 Bucket Name"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to deploy."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}

variable "key_name" {
  type        = string
  description = "AWS Account Key Name"
}