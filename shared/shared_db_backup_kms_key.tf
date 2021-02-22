resource "aws_kms_key" "db_backup" {
  description             = "KMS key for RDS backups"
  deletion_window_in_days = 10

  tags = {
    Name = "miiingle-shared-db-backup-key"
  }
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