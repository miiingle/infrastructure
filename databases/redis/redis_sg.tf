resource "aws_security_group" "redis" {
  name        = "${var.org}-${var.env}-redis-sg"
  description = "SG to Secure Access to our Redis Cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.org}-${var.env}-redis-sg"
  }, var.common_tags)
}