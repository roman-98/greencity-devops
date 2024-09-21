output "endpoint" {
  value = aws_eks_cluster.greencity.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.greencity.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.greencity.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.greencity.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.greencity.name
}