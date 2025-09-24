output "public_ip" {
    value = aws_instance.ubuntu_s3_mounter.public_ip
}