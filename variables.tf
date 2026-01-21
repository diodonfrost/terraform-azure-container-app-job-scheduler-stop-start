variable "container_app_job_name" {
  description = "The name of the Container App Job."
  type        = string
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Container App Job."
}

variable "location" {
  type        = string
  description = "The location of the Azure resources"
}

variable "job_replica_timeout" {
  description = "The timeout in seconds for each job replica."
  type        = number
  default     = 3600
}

variable "docker_image" {
  description = "The Docker image to use for the Container App Job."
  type        = string
  default     = "ghcr.io/diodonfrost/azure-scheduler-stop-start:0.0.1"
}

variable "scheduler_crontab_expression" {
  description = "The CRONTAB expression which defines the schedule of the Azure function app (UTC Time Zone) 5 fields"
  type        = string
  default     = "30 3 * * 2-5"
}

variable "scheduler_excluded_dates" {
  description = "List of specific dates to exclude from scheduling in MM-DD format (e.g., ['12-25', '01-01'])"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for date in var.scheduler_excluded_dates : can(regex("^(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$", date))
    ])
    error_message = "Excluded dates must be in MM-DD format (e.g., '12-25', '01-01')."
  }
}

variable "scheduler_action" {
  description = "The action to take for the scheduler, accepted values: 'stop' or 'start'"
  type        = string

  validation {
    condition     = var.scheduler_action == "stop" || var.scheduler_action == "start"
    error_message = "The scheduler_action variable must be either 'stop' or 'start'"
  }
}

variable "subscription_ids" {
  description = "List of Azure subscription IDs to manage resources in. If empty, uses the current subscription only."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for id in var.subscription_ids : can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", id))
    ])
    error_message = "All subscription IDs must be valid UUIDs."
  }
}

variable "scheduler_tag" {
  description = "Set the tag to use for identify Azure resources to stop or start"
  type        = map(string)

  default = {
    "tostop" = "true"
  }
}

variable "virtual_machine_schedule" {
  description = "Enable Azure Virtual Machine scheduler."
  type        = bool
  default     = false
}

variable "scale_set_schedule" {
  description = "Enable Azure Scale Set scheduler."
  type        = bool
  default     = false
}

variable "postgresql_schedule" {
  description = "Enable Azure Postgresql scheduler."
  type        = bool
  default     = false
}

variable "mysql_schedule" {
  description = "Enable Azure Mysql scheduler."
  type        = bool
  default     = false
}

variable "aks_schedule" {
  description = "Enable Azure AKS scheduler."
  type        = bool
  default     = false
}

variable "container_group_schedule" {
  description = "Enable Azure Container group scheduler."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID for Container App Job logs."
  type        = string
  default     = null
}

variable "external_container_app_environment" {
  description = "Use an external Container App Environment instead of creating a new one. Provide the name and resource_group_name."
  type = object({
    name                = string
    resource_group_name = string
  })
  default = null
}

variable "tags" {
  description = "The tags to apply to the Azure resources"
  type        = map(string)
  default     = {}
}
