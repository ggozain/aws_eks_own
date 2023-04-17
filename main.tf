data "tfe_outputs" "vpc" {
  organization = var.tfcloud_organization
  workspace    = var.tfcloud_workspace
}

module "aws_eks" {
  source = "./modules/aws_eks"
  subnet_ids = setunion(
    data.tfe_outputs.vpc.values.public_subnet_id,
  data.tfe_outputs.vpc.values.private_subnet_id)
  eks_kubernetes_version        = var.eks_kubernetes_version
  eks_cluster_iam_role_name     = var.eks_cluster_iam_role_name
  nodes_general_iam_role_name   = var.nodes_general_iam_role_name
  eks_cluster_name              = var.eks_cluster_name
  node_group_name               = var.node_group_name
  node_group_private_subnet_ids = data.tfe_outputs.vpc.values.private_subnet_id
  // scaling variables
  worker_nodes_desired_size = var.worker_nodes_desired_size
  worker_nodes_max_size     = var.worker_nodes_max_size
  worker_nodes_min_size     = var.worker_nodes_min_size
  worker_node_disk_size     = var.worker_node_disk_size
  // EC2 instances for worker nodes config
  force_update_version      = var.force_update_version
  capacity_type             = var.capacity_type
  ami_type                  = var.ami_type
  worker_node_instance_type = var.worker_node_instance_type
}