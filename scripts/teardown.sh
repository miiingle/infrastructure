terraform destroy -target 'module.eks.kubernetes_service.load_balancer' --auto-approve || { echo 'LB Deletion Failed' ; exit 1; }
terraform state rm 'module.eks.kubernetes_namespace.cloudwatch'
terraform state rm 'module.eks.kubernetes_secret.all_secrets'
terraform state rm 'module.eks.helm_release.application_user_api'
terraform state rm 'module.eks.helm_release.cloudwatch_utilities'
terraform state rm 'module.eks.helm_release.cluster_autoscaler'
terraform state rm 'module.eks.module.eks_cluster.kubernetes_config_map.aws_auth[0]'
terraform destroy --auto-approve