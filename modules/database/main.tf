resource "random_password" "db_password" {
  length  = 20
  special = false  # keeps it simple — avoids characters some tools mishandle
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.name_prefix}-db"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "ecommercedb"
  username               = "notesadmin"
  password               = random_password.db_password.result
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.data_sg_id]
  publicly_accessible    = false
  skip_final_snapshot    = true  # fine for learning; real production wants this false
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name_prefix}-cache-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.name_prefix}-cache"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [var.data_sg_id]
}

resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.name_prefix}/db_host"
  type  = "String"
  value = aws_db_instance.this.address
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.name_prefix}/db_password"
  type  = "SecureString"
  value = random_password.db_password.result
}

resource "aws_ssm_parameter" "cache_host" {
  name  = "/${var.name_prefix}/cache_host"
  type  = "String"
  value = aws_elasticache_cluster.this.cluster_address
}