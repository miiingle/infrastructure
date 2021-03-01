resource "aws_cloudwatch_log_group" "es" {
  name              = "/${var.org}-${var.env}/elasticsearch"
  retention_in_days = 7
}

//resource "aws_cloudwatch_log_resource_policy" "es" {
//  policy_name = "${var.org}-${var.env}-es-cw"
//
//  policy_document = <<CONFIG
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Effect": "Allow",
//      "Principal": {
//        "Service": "es.amazonaws.com"
//      },
//      "Action": [
//        "logs:PutLogEvents",
//        "logs:PutLogEventsBatch",
//        "logs:CreateLogStream"
//      ],
//      "Resource": "arn:aws:logs:*"
//    }
//  ]
//}
//CONFIG
//}