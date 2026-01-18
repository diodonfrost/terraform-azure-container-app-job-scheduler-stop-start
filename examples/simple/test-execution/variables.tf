variable "resource_group_name" {
  description = "The name of the resource group where resources are deployed"
  type        = string
}

variable "stop_container_app_job_name" {
  description = "The name of the Container App Job to execute"
  type        = string
}

variable "vm_1_to_stop_name" {
  description = "The name of the first VM to stop"
  type        = string
}

variable "vm_2_to_stop_name" {
  description = "The name of the second VM to stop"
  type        = string
}

variable "vm_3_to_stop_name" {
  description = "The name of the third VM to stop"
  type        = string
}

variable "vm_1_do_not_stop_name" {
  description = "The name of the first VM to not stop"
  type        = string
}

variable "vm_2_do_not_stop_name" {
  description = "The name of the second VM to not stop"
  type        = string
}
