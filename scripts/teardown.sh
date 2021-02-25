aws eks update-kubeconfig --name miiingle-dev-eks && \
kubectl delete svc miiingle-dev-eks-loadbalancer && \
terraform state rm 'module.kubernetes.kubernetes_service.load_balancer'
terraform state rm 'module.kubernetes.kubernetes_namespace.cloudwatch'
terraform state rm 'module.kubernetes.kubernetes_secret.all_secrets'
terraform state rm 'module.kubernetes.helm_release.application_user_api'
terraform state rm 'module.kubernetes.helm_release.cloudwatch_utilities'
terraform state rm 'module.kubernetes.helm_release.cluster_autoscaler'
terraform state rm 'module.kubernetes.module.eks_cluster.kubernetes_config_map.aws_auth[0]'
aws s3 rm s3://net.miiingle.dev.ops/ --recursive
terraform destroy --auto-approve