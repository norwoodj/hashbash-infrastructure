variable "region" {}

variable "ec2_key_pair" {}

variable "bastion_ami" {}

variable "enable_bastion" {
  default = true
}

variable "stack_name" {}
