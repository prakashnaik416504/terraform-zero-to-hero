variable "aws_region" {
  description = "AWS Region where infra will build."
  type        = string
}

variable "ami" {
  description = "OS image name"
  type        = string

}

variable "instance_type" {
  type = string
}