**********************************
 Terraform Resources in Module 9
**********************************
Services covered in this module: RDS, Redshift, Aurora, DynamoDB.


RDS (Relational Database)
-------------------------

Resources
^^^^^^^^^
* ``aws_db_cluster_snapshot``
* ``aws_db_event_subscription``
* ``aws_db_instance``
* ``aws_db_instance_automated_backups_replication``
* ``aws_db_instance_role_association``
* ``aws_db_option_group``
* ``aws_db_parameter_group``
* ``aws_db_proxy``
* ``aws_db_proxy_default_target_group``
* ``aws_db_proxy_endpoint``
* ``aws_db_proxy_target``
* ``aws_db_security_group``
* ``aws_db_snapshot``
* ``aws_db_snapshot_copy``
* ``aws_db_subnet_group``
* ``aws_rds_cluster``
* ``aws_rds_cluster_activity_stream``
* ``aws_rds_cluster_endpoint``
* ``aws_rds_cluster_instance``
* ``aws_rds_cluster_parameter_group``
* ``aws_rds_cluster_role_association``
* ``aws_rds_export_task``
* ``aws_rds_global_cluster``
* ``aws_rds_reserved_instance``

Data Sources
^^^^^^^^^^^^
* ``aws_db_cluster_snapshot``
* ``aws_db_event_categories``
* ``aws_db_instance``
* ``aws_db_instances``
* ``aws_db_proxy``
* ``aws_db_snapshot``
* ``aws_db_subnet_group``
* ``aws_rds_certificate``
* ``aws_rds_cluster``
* ``aws_rds_clusters``
* ``aws_rds_engine_version``
* ``aws_rds_orderable_db_instance``
* ``aws_rds_reserved_instance_offering``


DynamoDB
--------

Resources
^^^^^^^^^
* ``aws_dynamodb_contributor_insights``
* ``aws_dynamodb_global_table``
* ``aws_dynamodb_kinesis_streaming_destination``
* ``aws_dynamodb_table``
* ``aws_dynamodb_table_item``
* ``aws_dynamodb_table_replica``
* ``aws_dynamodb_tag``

Data Sources
^^^^^^^^^^^^
* ``aws_dynamodb_table``
* ``aws_dynamodb_table_item``


Redshift
--------

Resources
^^^^^^^^^
* ``aws_redshift_authentication_profile``
* ``aws_redshift_cluster``
* ``aws_redshift_cluster_iam_roles``
* ``aws_redshift_cluster_snapshot``
* ``aws_redshift_endpoint_access``
* ``aws_redshift_endpoint_authorization``
* ``aws_redshift_event_subscription``
* ``aws_redshift_hsm_client_certificate``
* ``aws_redshift_hsm_configuration``
* ``aws_redshift_parameter_group``
* ``aws_redshift_partner``
* ``aws_redshift_scheduled_action``
* ``aws_redshift_security_group``
* ``aws_redshift_snapshot_copy_grant``
* ``aws_redshift_snapshot_schedule``
* ``aws_redshift_snapshot_schedule_association``
* ``aws_redshift_subnet_group``
* ``aws_redshift_usage_limit``

Data Sources
^^^^^^^^^^^^
* ``aws_redshift_cluster``
* ``aws_redshift_cluster_credentials``
* ``aws_redshift_orderable_cluster``
* ``aws_redshift_service_account``
* ``aws_redshift_subnet_group``


Redshift Data
-------------

Resources
^^^^^^^^^
* ``aws_redshiftdata_statement``

Redshift Serverless
-------------------

Resources
^^^^^^^^^
* ``aws_redshiftserverless_endpoint_access``
* ``aws_redshiftserverless_namespace``
* ``aws_redshiftserverless_resource_policy``
* ``aws_redshiftserverless_snapshot``
* ``aws_redshiftserverless_usage_limit``
* ``aws_redshiftserverless_workgroup``

Data Sources
^^^^^^^^^^^^
* ``aws_redshiftserverless_credentials``
* ``aws_redshiftserverless_workgroup``
