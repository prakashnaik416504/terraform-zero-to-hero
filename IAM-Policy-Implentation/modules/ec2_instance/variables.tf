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

variable "region" {
  description = "aws region"
  type        = string
}

variable "aws_secret_key" {
  description = "aws secret key"
  type        = string
}

variable "bucket_var" {
  description = "s3 bucket variable"
  type = string
  
}