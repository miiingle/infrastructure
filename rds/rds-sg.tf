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