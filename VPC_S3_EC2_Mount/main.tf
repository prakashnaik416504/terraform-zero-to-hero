module "vpc" {
  source = "./modules/vpc"
}

module "s3_mount" {
  source        = "./modules/s3_mount"
  s3-bucket     = var.s3-bucket
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  # sg_name = module.vpc.ec2_sg
  sg_id     = module.vpc.ec2_sg_id
  subnet_id = module.vpc.subnet_id
}


