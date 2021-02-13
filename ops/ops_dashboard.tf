resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.org}-${var.env}-dashboard"
  dashboard_body = data.template_file.dashboard_main_json.rendered
}

data "template_file" "dashboard_main_json" {
  template = file("${path.module}/template/dashboard-main.json")
  vars = {
    region           = var.region
    metric_namespace = local.metric_namespace
    error_4xx_name   = aws_cloudwatch_log_metric_filter.api_gateway_error_4xx_count.metric_transformation.0.name
    error_5xx_name   = aws_cloudwatch_log_metric_filter.api_gateway_error_5xx_count.metric_transformation.0.name
    ok_2xx_name      = aws_cloudwatch_log_metric_filter.api_gateway_ok_2xx_count.metric_transformation.0.name
  }
}