resource "random_pet" "suffix" {}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "azurerm_resource_group" "test" {
  name     = "test-${random_pet.suffix.id}"
  location = "swedencentral"
}

resource "azurerm_log_analytics_workspace" "test" {
  name                = "test-${random_pet.suffix.id}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "test" {
  name                       = "test-${random_pet.suffix.id}"
  location                   = azurerm_resource_group.test.location
  resource_group_name        = azurerm_resource_group.test.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
}


module "stop_virtual_machines" {
  source = "../../"

  resource_group_name          = azurerm_resource_group.test.name
  location                     = azurerm_resource_group.test.location
  container_app_job_name       = "caj-to-stop-${random_pet.suffix.id}"
  scheduler_action             = "stop"
  scheduler_crontab_expression = "0 22 * * *"
  virtual_machine_schedule     = true
  external_container_app_environment = {
    name                = azurerm_container_app_environment.test.name
    resource_group_name = azurerm_container_app_environment.test.resource_group_name
  }
  scheduler_tag = {
    tostop = "true"
  }
}

module "start_virtual_machines" {
  source = "../../"

  resource_group_name          = azurerm_resource_group.test.name
  location                     = azurerm_resource_group.test.location
  container_app_job_name       = "caj-to-start-${random_pet.suffix.id}"
  scheduler_action             = "start"
  scheduler_crontab_expression = "0 22 * * *"
  virtual_machine_schedule     = true
  external_container_app_environment = {
    name                = azurerm_container_app_environment.test.name
    resource_group_name = azurerm_container_app_environment.test.resource_group_name
  }
  scheduler_tag = {
    tostop = "true"
  }
}
