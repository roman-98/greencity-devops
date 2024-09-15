output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "launch_template_id" {
  value = aws_launch_template.lt.id
}

output "desired_capacity" {
  value = aws_autoscaling_group.asg.desired_capacity
}
