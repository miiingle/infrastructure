
resource "aws_iam_role_policy_attachment" "cluster_CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = module.eks_cluster.worker_iam_role_name
}

//TODO: change this to a more restrictive role
//for now i just want to write the server logs to CW
resource "aws_iam_role_policy_attachment" "cluster_CloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = module.eks_cluster.worker_iam_role_name
}