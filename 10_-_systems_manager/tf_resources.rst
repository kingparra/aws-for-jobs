SSM (Systems Manager)
---------------------

Resources
^^^^^^^^^
* aws_ssm_activation -
  Register an on-prem server or VM with EC2 so it can
  be managed with Run Command.

* aws_ssm_association -
  Associates a SSM document to an instance or EC2 tag.
  A features of State Manager.

* aws_ssm_document -

  This is essentially a playbook for the SSM agents
  Run Command feature. It has it's own YAML schema.
  Here's an example of what one looks like.

  ::

    resource "aws_ssm_document" "foo" {
      name            = "test_document"
      document_format = "YAML"
      document_type   = "Command"

      content = <<DOC
    schemaVersion: '1.2'
    description: Check ip configuration of a Linux instance.
    parameters: {}
    runtimeConfig:
      'aws:runShellScript':
        properties:
          - id: '0.aws:runShellScript'
            runCommand:
              - ifconfig
    DOC
    }

* aws_ssm_parameter - A parameter for Parameter Store. Here's an example:

  ::

    resource "aws_ssm_parameter" "foo" {
      name  = "foo"
      type  = "String"
      value = "bar"
    }

* aws_ssm_maintenance_window
* aws_ssm_maintenance_window_target
* aws_ssm_maintenance_window_task
* aws_ssm_patch_baseline
* aws_ssm_patch_group
* aws_ssm_default_patch_baseline
* aws_ssm_resource_data_sync
* aws_ssm_service_setting

Data Sources
^^^^^^^^^^^^
aws_ssm_document
aws_ssm_instances
aws_ssm_maintenance_windows
aws_ssm_parameter
aws_ssm_parameters_by_path
aws_ssm_patch_baseline


Secrets Manager
---------------

Resources
^^^^^^^^^
aws_secretsmanager_secret
aws_secretsmanager_secret_policy
aws_secretsmanager_secret_rotation
aws_secretsmanager_secret_version

Data Sources
^^^^^^^^^^^^
aws_secretsmanager_random_password
aws_secretsmanager_secret
aws_secretsmanager_secret_rotation
aws_secretsmanager_secret_version
aws_secretsmanager_secrets


AppConfig
---------

Resources
^^^^^^^^^
aws_appconfig_application
aws_appconfig_configuration_profile
aws_appconfig_deployment
aws_appconfig_deployment_strategy
aws_appconfig_environment
aws_appconfig_extension
aws_appconfig_extension_association
aws_appconfig_hosted_configuration_version

Data Sources
^^^^^^^^^^^^
aws_appconfig_configuration_profile
aws_appconfig_configuration_profiles
aws_appconfig_environment
aws_appconfig_environments
