variable "aws_region" {
  description = "AWS Region name"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "IP range for the VPC"
  default     = "10.0.0.0/16"
}