resource "aws_db_instance" "db_transaction" {
  instance_class        = var.instance_type
  storage_type          = "gp2"
  allocated_storage     = 50
  max_allocated_storage = 1000
  identifier            = "${var.org}-${var.env}-rds"
  name                  = var.db_name
  username              = jsondecode(data.aws_secretsmanager_secret_version.db_backup_credentials.secret_string)["username"]
  password              = jsondecode(data.aws_secretsmanager_secret_version.db_backup_credentials.secret_string)["password"]

  engine                 = "postgres"
  engine_version         = "11.6"
  publicly_accessible    = false
  port                   = var.instance_port
  vpc_security_group_ids = [aws_security_group.db_transaction.id]
  db_subnet_group_name   = aws_db_subnet_group.transaction_db.name

  performance_insights_enabled = true

  snapshot_identifier     = var.snapshot_identifier
  backup_retention_period = 35
  backup_window           = "00:00-01:00"

  final_snapshot_identifier = "${var.org}-${var.env}-rds-final-snapshot-${formatdate("YYYYMMDDHHmm", timestamp())}"
  deletion_protection       = false

  lifecycle {
    ignore_changes = [final_snapshot_identifier, engine_version]
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

data "aws_secretsmanager_secret" "db_backup_credentials" {
  name = "miiingle-shared-db-backup-credentials"
}

data "aws_secretsmanager_secret_version" "db_backup_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_backup_credentials.id
}