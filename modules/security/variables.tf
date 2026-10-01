variable "vpc_id" {
  description = "The VPC these security groups belong to"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming, e.g. 'ecommerce-tf'"
  type        = string
}