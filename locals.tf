locals {
  # Determine the Container App Environment ID to use
  container_app_environment_id = var.external_container_app_environment != null ? data.azurerm_container_app_environment.external[0].id : azurerm_container_app_environment.this[0].id

  # Subscription configuration - use provided list or current subscription
  subscription_ids = length(var.subscription_ids) > 0 ? var.subscription_ids : [data.azurerm_subscription.current.subscription_id]
}
