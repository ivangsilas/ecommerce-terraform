terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
        random = {
        source  = "hashicorp/random"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"

  name_prefix           = "ecommerce-tf"
  vpc_cidr              = "10.10.0.0/16"
  public_subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs  = ["10.10.10.0/24", "10.10.11.0/24"]
  azs                   = ["us-east-1a", "us-east-1b"]
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}


module "security" {
  source = "./modules/security"

  vpc_id      = module.network.vpc_id
  name_prefix = "ecommerce-tf"
}

output "alb_sg_id" {
  value = module.security.alb_sg_id
}
output "ecs_sg_id" {
  value = module.security.ecs_sg_id
}
output "data_sg_id" {
  value = module.security.data_sg_id
}


module "database" {
  source = "./modules/database"

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  data_sg_id         = module.security.data_sg_id
  name_prefix        = "ecommerce-tf"
}

output "db_endpoint" {
  value = module.database.db_endpoint
}
output "cache_endpoint" {
  value = module.database.cache_endpoint
}


module "app" {
  source = "./modules/app"

  name_prefix           = "ecommerce-tf"
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  alb_sg_id             = module.security.alb_sg_id
  ecs_sg_id             = module.security.ecs_sg_id
  db_host_param_arn     = module.database.db_host_param_arn
  db_password_param_arn = module.database.db_password_param_arn
  cache_host_param_arn  = module.database.cache_host_param_arn
}

output "ecr_repository_url" {
  value = module.app.ecr_repository_url
}
output "alb_dns_name" {
  value = module.app.alb_dns_name
}
