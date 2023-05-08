Terraform
*********


Auto Scaling
------------
Resources
^^^^^^^^^
aws_autoscaling_attachment
aws_autoscaling_group
aws_autoscaling_group_tag
aws_autoscaling_lifecycle_hook
aws_autoscaling_notification
aws_autoscaling_policy
aws_autoscaling_schedule
aws_launch_configuration

Data Sources
^^^^^^^^^^^^
aws_autoscaling_group
aws_autoscaling_groups
aws_launch_configuration

Auto Scaling Plans
------------------
Resources
^^^^^^^^^
aws_autoscalingplans_scaling_plan



CloudFormation
**************

EC2 Auto Scaling
----------------
Resource types
^^^^^^^^^^^^^^
AWS::AutoScaling::AutoScalingGroup
AWS::AutoScaling::LaunchConfiguration
AWS::AutoScaling::LifecycleHook
AWS::AutoScaling::ScalingPolicy
AWS::AutoScaling::ScheduledAction
AWS::AutoScaling::WarmPool

AWS Auto Scaling
----------------
Resource types
^^^^^^^^^^^^^^
AWS::AutoScalingPlans::ScalingPlan

Application Auto Scaling
------------------------
Resource types
^^^^^^^^^^^^^^
AWS::ApplicationAutoScaling::ScalableTarget
AWS::ApplicationAutoScaling::ScalingPolicy


Awscli
******
There are three subcommands related to autoscaling:
``autoscaling``, ``application-autoscaling``, and ``autoscaling-plans``.

∿ aws autoscaling
attach-instances
attach-load-balancers
attach-load-balancer-target-groups
attach-traffic-sources
batch-delete-scheduled-action
batch-put-scheduled-update-group-action
cancel-instance-refresh
complete-lifecycle-action
create-auto-scaling-group
create-launch-configuration
create-or-update-tags
delete-auto-scaling-group
delete-launch-configuration
delete-lifecycle-hook
delete-notification-configuration
delete-policy
delete-scheduled-action
delete-tags
delete-warm-pool
describe-account-limits
describe-adjustment-types
describe-auto-scaling-groups
describe-auto-scaling-instances
describe-auto-scaling-notification-types
describe-instance-refreshes
describe-launch-configurations
describe-lifecycle-hooks
describe-lifecycle-hook-types
describe-load-balancers
describe-load-balancer-target-groups
describe-metric-collection-types
describe-notification-configurations
describe-policies
describe-scaling-activities
describe-scaling-process-types
describe-scheduled-actions
describe-tags
describe-termination-policy-types
describe-traffic-sources
describe-warm-pool
detach-instances
detach-load-balancers
detach-load-balancer-target-groups
detach-traffic-sources
disable-metrics-collection
enable-metrics-collection
enter-standby
execute-policy
exit-standby
get-predictive-scaling-forecast
put-lifecycle-hook
put-notification-configuration
put-scaling-policy
put-scheduled-update-group-action
put-warm-pool
record-lifecycle-action-heartbeat
resume-processes
rollback-instance-refresh
set-desired-capacity
set-instance-health
set-instance-protection
start-instance-refresh
suspend-processes
terminate-instance-in-auto-scaling-group
update-auto-scaling-group

∿ aws application-autoscaling
delete-scaling-policy
delete-scheduled-action
deregister-scalable-target
describe-scalable-targets
describe-scaling-activities
describe-scaling-policies
describe-scheduled-actions
put-scaling-policy
put-scheduled-action
register-scalable-target

∿ aws autoscaling-plans
create-scaling-plan
delete-scaling-plan
describe-scaling-plans
describe-scaling-plan-resources
get-scaling-plan-resource-forecast-data
update-scaling-plan

Elastic load balancing has two subcommands: ``elb`` and ``elbv2``.

∿ aws elb
add-tags
apply-security-groups-to-load-balancer
attach-load-balancer-to-subnets
configure-health-check
create-app-cookie-stickiness-policy
create-lb-cookie-stickiness-policy
create-load-balancer
create-load-balancer-listeners
create-load-balancer-policy
delete-load-balancer
delete-load-balancer-listeners
delete-load-balancer-policy
deregister-instances-from-load-balancer
describe-account-limits
describe-instance-health
describe-load-balancers
describe-load-balancer-attributes
describe-load-balancer-policies
describe-load-balancer-policy-types
describe-tags
detach-load-balancer-from-subnets
disable-availability-zones-for-load-balancer
enable-availability-zones-for-load-balancer
modify-load-balancer-attributes
register-instances-with-load-balancer
remove-tags
set-load-balancer-listener-ssl-certificate
set-load-balancer-policies-for-backend-server
set-load-balancer-policies-of-listener
wait

∿ aws elbv2
add-listener-certificates
add-tags
create-listener
create-load-balancer
create-rule
create-target-group
delete-listener
delete-load-balancer
delete-rule
delete-target-group
deregister-targets
describe-account-limits
describe-listeners
describe-listener-certificates
describe-load-balancers
describe-load-balancer-attributes
describe-rules
describe-ssl-policies
describe-tags
describe-target-groups
describe-target-group-attributes
describe-target-health
modify-listener
modify-load-balancer-attributes
modify-rule
modify-target-group
modify-target-group-attributes
register-targets
remove-listener-certificates
remove-tags
set-ip-address-type
set-rule-priorities
set-security-groups
set-subnets
wait
