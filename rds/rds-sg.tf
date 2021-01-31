resource "aws_security_group" "db_transaction" {
  name        = "${var.org}-${var.env}-rds-sg"
  description = "Allow Postgres traffic into RDS"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.org}-${var.env}-rds-sg"
  }, var.common_tags)
}

resource "aws_security_group" "db_transaction_proxy" {
  name        = "${var.org}-${var.env}-rds-sg-proxy"
  description = "Allow Postgres traffic into RDS Proxy"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.org}-${var.env}-rds-sg-proxy"
  }, var.common_tags)
}

resource "aws_security_group_rule" "rds_proxy_to_db_instance" {
  description              = "Proxy access to RDS Instance"
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_transaction.id
  source_security_group_id = aws_security_group.db_transaction_proxy.id
  type                     = "ingress"
}