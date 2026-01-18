locals {
  # Subscription configuration - use provided list or current subscription
  subscription_ids = length(var.subscription_ids) > 0 ? var.subscription_ids : [data.azurerm_subscription.current.subscription_id]
}
