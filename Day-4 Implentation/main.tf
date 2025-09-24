provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "remote_bakend" {
  ami           = var.ami
  instance_type = var.instance_type
}

resource "aws_s3_bucket" "demo_terraform_state_bucket411036541" {
  bucket = "tf-state-bucket-demo1"
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "tf_lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}