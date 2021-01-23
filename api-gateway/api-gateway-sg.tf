resource "aws_security_group" "apigw_sg" {
  name        = "${var.org}-${var.env}-apigw-sg"
  description = "Allow all traffic with in API-GW SG"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "apigw-sg-rule1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  security_group_id        = aws_security_group.apigw_sg.id
  source_security_group_id = aws_security_group.apigw_sg.id
}

resource "aws_security_group_rule" "apigw-sg-rule2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.apigw_sg.id
}