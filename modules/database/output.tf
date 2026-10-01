output "db_endpoint" {
  value = aws_db_instance.this.address
}

output "cache_endpoint" {
  value = aws_elasticache_cluster.this.cluster_address
}

output "db_host_param_arn" {
  value = aws_ssm_parameter.db_host.arn
}
output "db_password_param_arn" {
  value = aws_ssm_parameter.db_password.arn
}
output "cache_host_param_arn" {
  value = aws_ssm_parameter.cache_host.arn
}