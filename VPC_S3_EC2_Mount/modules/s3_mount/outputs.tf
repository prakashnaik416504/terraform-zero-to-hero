# output "vpc_id" {
#   value = aws_vpc.custom_vpc.id
# }

output "public_ip" {
  value = aws_instance.ubuntu_s3_mounter.public_ip

}

