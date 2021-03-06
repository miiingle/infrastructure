
resource "aws_iam_role_policy_attachment" "cluster_CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = module.eks_cluster.worker_iam_role_name
}

//TODO: we probably only need the agent policy, not this
//resource "aws_iam_role_policy_attachment" "cluster_CloudWatchFullAccess" {
//  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
//  role       = module.eks_cluster.worker_iam_role_name
//}

resource "aws_iam_role_policy_attachment" "cluster_AWSXRayDaemonWriteAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = module.eks_cluster.worker_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = module.eks_cluster.worker_iam_role_name
}