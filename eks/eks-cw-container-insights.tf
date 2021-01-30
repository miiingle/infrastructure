
//TODO: figure this out without needing cloudwatch-agent.yml

//resource "kubernetes_config_map" "cwagent_config" {
//  metadata {
//    name      = "cwagentconfig"
//    namespace = local.cloudwatch_namespace
//  }
//
//  data = {
//    "cwagentconfig.json" = jsonencode(
//      {
//        agent = {
//          region = var.aws_region
//        }
//        logs = {
//          force_flush_interval = 5
//          metrics_collected = {
//            kubernetes = {
//              cluster_name                = var.eks_cluster_name
//              metrics_collection_interval = 60
//            }
//          }
//        }
//        metrics = {
//          metrics_collected = {
//            statsd = {
//              service_address = ":8125"
//            }
//          }
//        }
//      }
//    )
//  }
//}

//TODO: apply cloudwatch-agent.yml