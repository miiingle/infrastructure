output "sg_id" {
  value = aws_security_group.es.id
}

output "endpoint" {
  value = aws_elasticsearch_domain.elasticsearch.endpoint
}