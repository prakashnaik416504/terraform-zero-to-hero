variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"
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

variable "sns_endpoint_email" {
  description = "The email address for SNS notifications."
  type        = string
}
