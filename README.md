# terraform-azure-container-app-job-scheduler-stop-start

Terraform module which creates Azure Container App Jobs to automatically stop and start Azure resources on a schedule.

## Supported Resources

- Virtual Machines
- Virtual Machine Scale Sets
- AKS Clusters
- PostgreSQL Flexible Servers
- MySQL Flexible Servers
- Container Groups

## Usage

```hcl
module "stop_resources" {
  source = "diodonfrost/container-app-job-scheduler-stop-start/azure"

  resource_group_name          = "my-rg"
  location                     = "westeurope"
  container_app_job_name       = "my-scheduler-stop"
  scheduler_action             = "stop"
  scheduler_crontab_expression = "0 22 * * *"
  virtual_machine_schedule     = true
  postgresql_schedule          = true
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.example.id
  scheduler_tag = {
    tostop = "true"
  }
}

module "start_resources" {
  source = "diodonfrost/container-app-job-scheduler-stop-start/azure"

  resource_group_name          = "my-rg"
  location                     = "westeurope"
  container_app_job_name       = "my-scheduler-start"
  scheduler_action             = "start"
  scheduler_crontab_expression = "0 7 * * *"
  virtual_machine_schedule     = true
  postgresql_schedule          = true
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.example.id
  scheduler_tag = {
    tostop = "true"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_container_app_job.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_job) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_schedule"></a> [aks\_schedule](#input\_aks\_schedule) | Enable Azure AKS scheduler. | `bool` | `false` | no |
| <a name="input_container_app_job_name"></a> [container\_app\_job\_name](#input\_container\_app\_job\_name) | The name of the Container App Job. | `string` | n/a | yes |
| <a name="input_container_group_schedule"></a> [container\_group\_schedule](#input\_container\_group\_schedule) | Enable Azure Container group scheduler. | `bool` | `false` | no |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | The Docker image to use for the Container App Job. | `string` | `"ghcr.io/diodonfrost/azure-scheduler-stop-start:0.0.1"` | no |
| <a name="input_job_replica_timeout"></a> [job\_replica\_timeout](#input\_job\_replica\_timeout) | The timeout in seconds for each job replica. | `number` | `3600` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the Azure resources | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The Log Analytics Workspace ID for Container App Job logs. | `string` | `null` | no |
| <a name="input_mysql_schedule"></a> [mysql\_schedule](#input\_mysql\_schedule) | Enable Azure Mysql scheduler. | `bool` | `false` | no |
| <a name="input_postgresql_schedule"></a> [postgresql\_schedule](#input\_postgresql\_schedule) | Enable Azure Postgresql scheduler. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group in which to create the Container App Job. | `string` | n/a | yes |
| <a name="input_scale_set_schedule"></a> [scale\_set\_schedule](#input\_scale\_set\_schedule) | Enable Azure Scale Set scheduler. | `bool` | `false` | no |
| <a name="input_scheduler_action"></a> [scheduler\_action](#input\_scheduler\_action) | The action to take for the scheduler, accepted values: 'stop' or 'start' | `string` | n/a | yes |
| <a name="input_scheduler_crontab_expression"></a> [scheduler\_crontab\_expression](#input\_scheduler\_crontab\_expression) | The CRONTAB expression which defines the schedule of the Azure function app (UTC Time Zone) 5 fields | `string` | `"30 3 * * 2-5"` | no |
| <a name="input_scheduler_excluded_dates"></a> [scheduler\_excluded\_dates](#input\_scheduler\_excluded\_dates) | List of specific dates to exclude from scheduling in MM-DD format (e.g., ['12-25', '01-01']) | `list(string)` | `[]` | no |
| <a name="input_scheduler_tag"></a> [scheduler\_tag](#input\_scheduler\_tag) | Set the tag to use for identify Azure resources to stop or start | `map(string)` | <pre>{<br/>  "tostop": "true"<br/>}</pre> | no |
| <a name="input_subscription_ids"></a> [subscription\_ids](#input\_subscription\_ids) | List of Azure subscription IDs to manage resources in. If empty, uses the current subscription only. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the Azure resources | `map(string)` | `{}` | no |
| <a name="input_virtual_machine_schedule"></a> [virtual\_machine\_schedule](#input\_virtual\_machine\_schedule) | Enable Azure Virtual Machine scheduler. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_app_job_id"></a> [container\_app\_job\_id](#output\_container\_app\_job\_id) | The ID of the container app job |
| <a name="output_container_app_job_name"></a> [container\_app\_job\_name](#output\_container\_app\_job\_name) | The name of the container app job |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group |
<!-- END_TF_DOCS -->

## Examples

- [simple](./examples/simple) - VM scheduler with integration tests
- [aks_scheduler](./examples/aks_scheduler) - AKS cluster scheduler
- [postgresql_scheduler](./examples/postgresql_scheduler) - PostgreSQL Flexible Server scheduler
- [mysql_scheduler](./examples/mysql_scheduler) - MySQL Flexible Server scheduler
- [scale_set_scheduler](./examples/scale_set_scheduler) - Virtual Machine Scale Set scheduler
- [container_group](./examples/container_group) - Container Group scheduler

## Tests

Some of these tests create real resources in an Azure subscription. That means they cost money to run, especially if you don't clean up after yourself. Please be considerate of the resources you create and take extra care to clean everything up when you're done!

In order to run tests that access your Azure subscription, run `az login`  and
`export ARM_SUBSCRIPTION_ID="your-subscription-id"` to set the subscription context.

### End-to-end tests

```shell
# Test VM scheduler
cd examples/simple
terraform init
terraform test -verbose
```

## Authors

Modules managed by diodonfrost.

## Licence

Apache Software License 2.0.
