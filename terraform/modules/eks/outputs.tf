output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}

output "eks_cluster_version" {
  value = aws_eks_cluster.eks.version
}

output "eks_node_group_arn" {
  value = aws_eks_node_group.eks_node_group.arn
}
