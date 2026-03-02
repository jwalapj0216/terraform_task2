variable "region_1" {
  default = "us-east-1"
}

variable "region_2" {
  default = "us-west-2"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS key new"
}
