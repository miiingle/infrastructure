resource "aws_security_group" "es" {
  name        = "${var.org}-${var.env}-es-sg"
  description = "SG to Secure Access to our ES Instances"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.org}-${var.env}-es-sg"
  }, var.common_tags)
}