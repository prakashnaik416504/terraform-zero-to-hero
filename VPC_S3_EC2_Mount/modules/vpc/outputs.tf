# output "vpc_id" {
#   value = aws_vpc.custom_vpc.id
# }
# output "public_ip" {
#   value = aws_instance.test1.public_ip

# }

# output "ec2_sg" {
#   value = aws_security_group.ec2_sg.name
# }

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "subnet_id"{
    value = aws_subnet.public_subnet.id
    
}

