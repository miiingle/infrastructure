locals {
  domain_name = "${var.org}-${var.env}-es"
}

resource "aws_elasticsearch_domain" "elasticsearch" {
  depends_on = [aws_cloudwatch_log_resource_policy.es]

  domain_name           = local.domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
  }

  vpc_options {
    subnet_ids         = [var.private_subnets[0]]
    security_group_ids = [aws_security_group.es.id]
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es.arn
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es.arn
  }

  access_policies = data.aws_iam_policy_document.es_access_policy_allow_all.json

  tags = merge({
    Domain = "${var.org}-${var.env}-es"
  }, var.common_tags)
}