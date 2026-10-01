variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "data_sg_id" {
  type = string
}

variable "name_prefix" {
  type = string
}