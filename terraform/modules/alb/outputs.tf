output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
