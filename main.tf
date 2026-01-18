data "azurerm_subscription" "current" {}

resource "azurerm_container_app_environment" "this" {
  name                       = var.container_app_job_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  tags = var.tags
}

resource "azurerm_container_app_job" "this" {
  name                         = var.container_app_job_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id

  replica_timeout_in_seconds = var.job_replica_timeout

  schedule_trigger_config {
    cron_expression = var.scheduler_crontab_expression
  }

  identity {
    type = "SystemAssigned"
  }

  template {
    container {
      name   = "scheduler"
      image  = var.docker_image
      cpu    = 1
      memory = "2Gi"

      env {
        name  = "SCHEDULER_ACTION"
        value = var.scheduler_action
      }

      env {
        name  = "SCHEDULER_EXCLUDED_DATES"
        value = jsonencode(var.scheduler_excluded_dates)
      }

      env {
        name  = "CURRENT_SUBSCRIPTION_ID"
        value = data.azurerm_subscription.current.subscription_id
      }

      env {
        name  = "SUBSCRIPTION_IDS"
        value = jsonencode(local.subscription_ids)
      }

      env {
        name  = "SCHEDULER_TAG"
        value = jsonencode(var.scheduler_tag)
      }

      env {
        name  = "VIRTUAL_MACHINE_SCHEDULE"
        value = tostring(var.virtual_machine_schedule)
      }

      env {
        name  = "SCALE_SET_SCHEDULE"
        value = tostring(var.scale_set_schedule)
      }

      env {
        name  = "POSTGRESQL_SCHEDULE"
        value = tostring(var.postgresql_schedule)
      }

      env {
        name  = "MYSQL_SCHEDULE"
        value = tostring(var.mysql_schedule)
      }

      env {
        name  = "AKS_SCHEDULE"
        value = tostring(var.aks_schedule)
      }

      env {
        name  = "CONTAINER_GROUP_SCHEDULE"
        value = tostring(var.container_group_schedule)
      }
    }
  }

  tags = var.tags
}
