resource "aws_autoscaling_group" "asg" {
  name = "webserver-cluster"
  launch_template {
    id = aws_launch_template.lt.id
    version = "$Latest"
  }
  availability_zones = [ "us-east-1a"
                       , "us-east-1b"
                       , "us-east-1c"
                       , "us-east-1d"
                       , "us-east-1e"
                       , "us-east-1f"
                       ]
  health_check_type = "ELB"
  health_check_grace_period = 120
  // This corresponds to checking "enable group metrics collection" in the web ui.
  metrics_granularity = "1Minute"
  enabled_metrics = [ "GroupPendingInstances"
                    , "GroupDesiredCapacity"
                    , "GroupInServiceCapacity"
                    , "GroupInServiceInstances"
                    , "GroupMaxSize"
                    , "WarmPoolPendingCapacity"
                    , "WarmPoolTerminatingCapacity"
                    , "GroupTerminatingCapacity"
                    , "WarmPoolTotalCapacity"
                    , "GroupPendingCapacity"
                    , "GroupTerminatingInstances"
                    , "WarmPoolMinSize"
                    , "GroupAndWarmPoolDesiredCapacity"
                    , "GroupTotalInstances"
                    , "WarmPoolDesiredCapacity"
                    , "WarmPoolWarmedCapacity"
                    , "GroupAndWarmPoolTotalCapacity"
                    , "GroupStandbyCapacity"
                    , "GroupTotalCapacity"
                    , "GroupMinSize"
                    , "GroupStandbyInstances"
                    ]
  min_size = 1
  desired_capacity = 1
  max_size = 5
}


resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_elb.elb.id
}


resource "aws_autoscaling_policy" "sp3" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name = "Project scaling policy"
  policy_type = "PredictiveScaling"
  ##############################################################
  ## This whole block is to say "80% average cpu utilization" ##
  ##############################################################
  predictive_scaling_configuration {
    metric_specification {
      target_value = 80
      customized_load_metric_specification {
        metric_data_queries {
          id = "load_sum"
          expression = "SUM(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" ${aws_autoscaling_group.asg.name}', 'Sum', 3600))"
        }
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace = "AWS/EC2"
              dimensions {
                name = "AutoScalingGroupName"
                value = aws_autoscaling_group.asg.name
              }
            }
            stat = "Average"
          }
        }
      }
      customized_capacity_metric_specification {
        metric_data_queries {
          id = "capacity_sum"
          expression = "SUM(SEARCH('{AWS/AutoScaling,AutoScalingGroupName} MetricName=\"GroupInServiceIntances\" my-test-asg', 'Average', 300))"
          return_data = false
        }
        metric_data_queries {
          id = "load_sum"
          expression = "SUM(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" my-test-asg', 'Sum', 300))"
          return_data = false
        }
        metric_data_queries {
          id = "weighted_average"
          expression = "load_sum / capacity_sum"
        }
      }
    }
  }
}
