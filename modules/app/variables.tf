variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "alb_sg_id" { type = string }
variable "ecs_sg_id" { type = string }

variable "db_host_param_arn" { type = string }
variable "db_password_param_arn" { type = string }
variable "cache_host_param_arn" { type = string }