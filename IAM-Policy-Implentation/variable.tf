variable "region" {
  description = "aws region"
  type        = string
}

variable "s3-bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "ami_id" {
  description = "AMI id for the aws instance."
  type        = string
}

variable "key_name" {
  description = "AWS Key Name"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
}

variable "aws_access_key" {
  description = "Aws Access Key"
  type        = string

}

variable "aws_secret_key" {
  description = "aws secret key"
  type        = string
}