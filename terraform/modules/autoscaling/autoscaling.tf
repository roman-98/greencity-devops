provider "aws" {
  region = var.region
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${var.name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }

  key_name = var.key_name

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.name}-instance"
      Environment = var.env
    }
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      delete_on_termination = true
    }
  }

  user_data = base64encode(var.user_data)

  depends_on = [aws_security_group.rds_sg]

}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets_ids

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }

  target_group_arns = var.target_group_arns

  health_check_type         = "EC2"
  health_check_grace_period = 300

  force_delete = false

  depends_on = [aws_launch_template.lt]

}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.name}-scale-up"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  autoscaling_group_name  = aws_autoscaling_group.asg.name

  depends_on = [aws_autoscaling_group.asg]

}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.name}-scale-down"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  autoscaling_group_name  = aws_autoscaling_group.asg.name

  depends_on = [aws_autoscaling_policy.scale_up]

}
