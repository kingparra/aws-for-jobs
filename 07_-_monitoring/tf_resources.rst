Terraform resources
*******************
This is just a dump of resources and data sources for the various AWS services covered in this module.
The idea is to use it as a checklist; I should at least be able to write a one-line summary of what each resource does.

CloudWatch
----------
Resources
aws_cloudwatch_composite_alarm
aws_cloudwatch_dashboard
aws_cloudwatch_metric_alarm
aws_cloudwatch_metric_stream

CloudWatch Application Insights
-------------------------------
Resources
aws_applicationinsights_application

CloudWatch Evidently
--------------------
Resources
aws_evidently_feature
aws_evidently_launch
aws_evidently_project
aws_evidently_segment

CloudWatch Logs
---------------
Resources
aws_cloudwatch_log_data_protection_policy
aws_cloudwatch_log_destination
aws_cloudwatch_log_destination_policy
aws_cloudwatch_log_group
aws_cloudwatch_log_metric_filter
aws_cloudwatch_log_resource_policy
aws_cloudwatch_log_stream
aws_cloudwatch_log_subscription_filter
aws_cloudwatch_query_definition

Data Sources
aws_cloudwatch_log_data_protection_policy_document
aws_cloudwatch_log_group
aws_cloudwatch_log_groups

CloudWatch Observability Access Manager
---------------------------------------
Resources
aws_oam_link
aws_oam_sink
aws_oam_sink_policy

Data Sources
aws_oam_link
aws_oam_links
aws_oam_sink
aws_oam_sinks

CloudWatch RUM
--------------
Resources
aws_rum_app_monitor
aws_rum_metrics_destination

CloudWatch Synthetics
---------------------
Resources
aws_synthetics_canary

SNS (Simple Notification)
-------------------------
Resources
aws_sns_platform_application
aws_sns_sms_preferences
aws_sns_topic
aws_sns_topic_data_protection_policy
aws_sns_topic_policy
aws_sns_topic_subscription

Data Sources
aws_sns_topic


EventBridge
-----------
Resources
aws_cloudwatch_event_api_destination
aws_cloudwatch_event_archive
aws_cloudwatch_event_bus
aws_cloudwatch_event_bus_policy
aws_cloudwatch_event_connection
aws_cloudwatch_event_endpoint
aws_cloudwatch_event_permission
aws_cloudwatch_event_rule
aws_cloudwatch_event_target

Data Sources
aws_cloudwatch_event_bus
aws_cloudwatch_event_connection
aws_cloudwatch_event_source

EventBridge Pipes
-----------------
Resources
aws_pipes_pipe

EventBridge Scheduler
---------------------
Resources
aws_scheduler_schedule
aws_scheduler_schedule_group

EventBridge Schemas
-------------------
Resources
aws_schemas_discoverer
aws_schemas_registry
aws_schemas_registry_policy
aws_schemas_schema
