output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "public_ip" {
  value = aws_instance.test1.public_ip

}