output "instance_id" {
  value = aws_db_instance.db_transaction.id
}

output "instance_sg_id" {
  value = aws_security_group.db_transaction_proxy.id
}

output "host" {
  value = aws_db_proxy.db_transaction.endpoint
}

output "master_username" {
  value = random_string.rds_username.result
}

output "master_password" {
  value = random_password.rds_password.result
}