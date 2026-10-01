variable "name_prefix" {
  description = "Prefix for naming all resources, e.g. 'ecommerce'"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the whole VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks, one per public subnet"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks, one per private subnet"
  type        = list(string)
}

variable "azs" {
  description = "List of Availability Zones to spread subnets across"
  type        = list(string)
}