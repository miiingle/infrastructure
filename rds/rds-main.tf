resource "aws_db_instance" "db_transaction" {
  instance_class        = var.instance_type
  storage_type          = "gp2"
  allocated_storage     = 50
  max_allocated_storage = 1000
  identifier            = "${var.org}-${var.env}-rds-${random_pet.rds_instance_name.id}"
  username              = random_string.rds_username.result
  password              = random_password.rds_password.result

  engine                 = "postgres"
  engine_version         = "11.6"
  publicly_accessible    = false
  port                   = var.instance_port
  vpc_security_group_ids = []
  db_subnet_group_name   = aws_db_subnet_group.transaction_db.name

  final_snapshot_identifier = "${var.org}-${var.env}-rds-${random_pet.rds_instance_name.id}-final-snapshot-${formatdate("YYYYMMDDHHmm", timestamp())}"
  deletion_protection       = false

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }

  tags = var.common_tags
}

resource "aws_db_subnet_group" "transaction_db" {
  name       = "${var.org}-${var.env}-rds-subnet-group"
  subnet_ids = var.subnets

  tags = merge({
    Name = "RDS Subnets"
  }, var.common_tags)
}

resource "random_string" "rds_username" {
  length  = 10
  special = false
  number  = false
  upper   = false
}

resource "random_password" "rds_password" {
  length  = 32
  special = false
}

resource "random_pet" "rds_instance_name" {}