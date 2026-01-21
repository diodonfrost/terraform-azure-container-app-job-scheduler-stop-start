run "create_test_infrastructure" {
  command = apply

  variables {
    test_mode = true
  }

  assert {
    condition     = module.stop_virtual_machines.resource_group_name == azurerm_resource_group.test.name
    error_message = "Invalid resource group name"
  }

  assert {
    condition     = module.stop_virtual_machines.resource_group_name == azurerm_resource_group.test.name
    error_message = "Invalid resource group name"
  }

  assert {
    condition     = module.stop_virtual_machines.container_app_job_name == "caj-to-stop-${random_pet.suffix.id}"
    error_message = "Invalid container app job name"
  }

  assert {
    condition     = module.start_virtual_machines.container_app_job_name == "caj-to-start-${random_pet.suffix.id}"
    error_message = "Invalid container app job name"
  }
}
