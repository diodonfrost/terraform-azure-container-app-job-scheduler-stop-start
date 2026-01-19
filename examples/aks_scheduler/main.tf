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

resource "azurerm_kubernetes_cluster" "to_stop" {
  count = 2

  name                = "to-stop-${count.index}-${random_pet.suffix.id}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  dns_prefix          = "to-stop-${count.index}-${random_pet.suffix.id}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    tostop = "true"
  }
}

resource "azurerm_kubernetes_cluster" "do_not_stop" {
  count = 2

  name                = "do-not-stop-${count.index}-${random_pet.suffix.id}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  dns_prefix          = "do-not-stop-${count.index}-${random_pet.suffix.id}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    tostop = "false"
  }
}

module "stop_aks_cluster" {
  source = "../../"

  resource_group_name          = azurerm_resource_group.test.name
  location                     = azurerm_resource_group.test.location
  container_app_job_name       = "caj-to-stop-${random_pet.suffix.id}"
  scheduler_action             = "stop"
  scheduler_crontab_expression = "0 22 * * *"
  aks_schedule                 = "true"
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.test.id
  scheduler_tag = {
    tostop = "true"
  }
}

module "start_aks_cluster" {
  source = "../../"

  resource_group_name          = azurerm_resource_group.test.name
  location                     = azurerm_resource_group.test.location
  container_app_job_name       = "caj-to-start-${random_pet.suffix.id}"
  scheduler_action             = "start"
  scheduler_crontab_expression = "0 7 * * *"
  aks_schedule                 = "true"
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.test.id
  scheduler_tag = {
    tostop = "true"
  }
}
