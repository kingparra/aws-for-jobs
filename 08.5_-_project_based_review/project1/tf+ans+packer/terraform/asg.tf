resource "aws_autoscaling_group" "site_asg" {
  name = "EnergymAsg"
  vpc_zone_identifier = data.aws_subnets.default_vpc_subnets.ids
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.site_lt.id
      }
    }
  }
  health_check_type = "ELB"
  min_size = 1
  desired_capacity = 2
  max_size = 3
  tag {
    key = "Name"
    value = "EnergymStaticSiteInstance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_gt_70" {
  name = "EnergymCpuGt70Policy"
  autoscaling_group_name = aws_autoscaling_group.site_asg.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
    target_value = 70.0
  }
}
