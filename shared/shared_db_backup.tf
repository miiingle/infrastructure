
//this is the minimum requirement for performing a db backup and restore:
// (1) encryption key for the db backup
// (2) master username and password
//TODO: send notification for these changes: kms deleted, secrets, backup created

resource "aws_kms_key" "db_backup" {
  description             = "KMS key for RDS backups"
  deletion_window_in_days = 10

  tags = {
    Name = "miiingle-shared-db-backup-key"
  }
}

resource "aws_secretsmanager_secret" "db_backup_credentials" {
  name                    = "miiingle-shared-db-backup-credentials"
  recovery_window_in_days = 0 //TODO: change this once we are sure
}

resource "aws_secretsmanager_secret_version" "db_backup_credentials" {
  secret_id     = aws_secretsmanager_secret.db_backup_credentials.id
  secret_string = data.template_file.rds_secrets.rendered
}

data "template_file" "rds_secrets" {
  template = file("${path.module}/template/rds-secrets.json")
  vars = {
    username = "postgres"
    password = random_password.rds_password.result
  }
}

resource "random_password" "rds_password" {
  length  = 32
  special = false
}

resource "aws_kms_alias" "db_backup" {
  name          = "alias/miiingle-shared-db-backup"
  target_key_id = aws_kms_key.db_backup.key_id
}

resource "aws_iam_role" "db_backup" {
  name               = "miiingle-shared-db-backup-role"
  assume_role_policy = data.template_file.db_backup_assume_role_policy.rendered
}

data "template_file" "db_backup_assume_role_policy" {
  template = file("${path.module}/template/db_backup_assume_role_policy.json")
}

resource "aws_iam_role_policy" "db_backup_role_inline_policy" {
  name   = "miiingle-shared-db-backup-role-inline-policy"
  role   = aws_iam_role.db_backup.id
  policy = data.template_file.db_backup_role_policy.rendered
}

data "template_file" "db_backup_role_policy" {
  template = file("${path.module}/template/db_backup_policy.json")

  vars = {
    kms_key_arn   = aws_kms_key.db_backup.arn
    s3_bucket_arn = aws_s3_bucket.backend.arn
  }
}