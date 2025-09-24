terraform {
  backend "s3" {
    bucket       = "tf-state-bucket-demo1"
    key          = "prakash/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
    region       = "ap-south-1"
  }
}