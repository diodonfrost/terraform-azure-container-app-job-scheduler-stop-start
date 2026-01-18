output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_container_app_job.this.resource_group_name
}

output "container_app_job_id" {
  description = "The ID of the container app job"
  value       = azurerm_container_app_job.this.id
}

output "container_app_job_name" {
  description = "The name of the container app job"
  value       = azurerm_container_app_job.this.name
}
