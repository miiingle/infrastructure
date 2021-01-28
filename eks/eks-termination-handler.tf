provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}

//following this guide
//https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/spot-instances.md
//TODO: dont use helm, just plain old k8 from the generated files
//resource "helm_release" "k8s_spot_termination_handler" {
//  name      = "k8s-spot-termination-handler"
//  chart     = "stable/k8s-spot-termination-handler"
//  namespace = "kube-system"
//
//  depends_on = [
//    module.eks_cluster
//  ]
//}