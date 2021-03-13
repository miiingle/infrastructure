
resource "aws_db_proxy" "db_transaction" {
  name                   = "${var.org}-${var.env}-rds-proxy"
  debug_logging          = true
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.iam_for_db_credentials.arn
  vpc_security_group_ids = [aws_security_group.db_transaction_proxy.id]
  vpc_subnet_ids         = var.subnets

  //noinspection HCLUnknownBlockType
  auth {
    auth_scheme = "SECRETS"
    description = "Credentials for RDS Proxy"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.db_transaction_credentials.arn
  }

  tags = var.common_tags
}

resource "aws_db_proxy_default_target_group" "db_transaction_proxy_target_group" {
  db_proxy_name = aws_db_proxy.db_transaction.name

  connection_pool_config {
    init_query                   = "select 1"
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "db_transaction_proxy_target" {
  db_instance_identifier = aws_db_instance.db_transaction.id
  db_proxy_name          = aws_db_proxy.db_transaction.name
  target_group_name      = aws_db_proxy_default_target_group.db_transaction_proxy_target_group.name
}

resource "aws_secretsmanager_secret" "db_transaction_credentials" {
  name                    = "${var.org}-${var.env}-rds-credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "psql-secret" {
  secret_id     = aws_secretsmanager_secret.db_transaction_credentials.id
  secret_string = data.template_file.rds_secrets.rendered
}

data "template_file" "rds_secrets" {
  template = file("${path.module}/template/rds-secrets.json")
  vars = {
    username             = aws_db_instance.db_transaction.username
    password             = aws_db_instance.db_transaction.password
    host                 = aws_db_instance.db_transaction.address
    engine               = "postgres"
    dbname               = var.db_name
    port                 = var.instance_port
    dbInstanceIdentifier = aws_db_instance.db_transaction.id
  }
}

resource "aws_iam_role" "iam_for_db_credentials" {
  name               = "${var.org}-${var.env}-psql-for-dbproxy"
  assume_role_policy = data.aws_iam_policy_document.secret_assume_role_policy_document.json
}

data "aws_iam_policy_document" "secret_assume_role_policy_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "rds.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "rds_instance_credentials" {
  name = "${var.org}-${var.env}-psql-for-dbproxy-policy"
  role = aws_iam_role.iam_for_db_credentials.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:*",
            "Resource": ["${aws_secretsmanager_secret.db_transaction_credentials.arn}"]
        }
    ]
}
EOF
}