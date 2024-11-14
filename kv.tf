provider "azurerm" {
  features {}
}

# Data source for Key Vault
data "azurerm_key_vault" "example" {
  name                = "your-key-vault-name"
  resource_group_name = "your-resource-group"
}

# Step 1: Define a map in locals with all 32 keys
locals {
  # Custom key map where each custom name (e.g., dbfs_dev_key) points to the actual Key Vault key name (e.g., dbfs-dev)
  key_map = {
    dbfs_dev_key               = "dbfs-dev"
    managed_services_dev_key    = "managed-services-dev"
    managed_disk_dev_key        = "managed-disk-dev"
    storage_dev_key             = "storage-dev"
    
    dbfs_test_key               = "dbfs-test"
    managed_services_test_key   = "managed-services-test"
    managed_disk_test_key       = "managed-disk-test"
    storage_test_key            = "storage-test"
    
    dbfs_acc_key                = "dbfs-acc"
    managed_services_acc_key    = "managed-services-acc"
    managed_disk_acc_key        = "managed-disk-acc"
    storage_acc_key             = "storage-acc"
    
    dbfs_prod_key               = "dbfs-prod"
    managed_services_prod_key   = "managed-services-prod"
    managed_disk_prod_key       = "managed-disk-prod"
    storage_prod_key            = "storage-prod"
    
    # Non-prod keys (np)
    dbfs_np_dev_key             = "dbfs-np-dev"
    managed_services_np_dev_key = "managed-services-np-dev"
    managed_disk_np_dev_key     = "managed-disk-np-dev"
    storage_np_dev_key          = "storage-np-dev"
    
    dbfs_np_test_key            = "dbfs-np-test"
    managed_services_np_test_key= "managed-services-np-test"
    managed_disk_np_test_key    = "managed-disk-np-test"
    storage_np_test_key         = "storage-np-test"
    
    dbfs_np_acc_key             = "dbfs-np-acc"
    managed_services_np_acc_key = "managed-services-np-acc"
    managed_disk_np_acc_key     = "managed-disk-np-acc"
    storage_np_acc_key          = "storage-np-acc"
    
    dbfs_np_prod_key            = "dbfs-np-prod"
    managed_services_np_prod_key= "managed-services-np-prod"
    managed_disk_np_prod_key    = "managed-disk-np-prod"
    storage_np_prod_key         = "storage-np-prod"
  }

  # Step 2: Use the custom key names from key_map to create a map of Key Vault values
  key_values = {
    for custom_key, actual_key in local.key_map :
    custom_key => data.azurerm_key_vault_key[actual_key].value
  }
}

# Step 3: Define a data source for each Key Vault key based on key_map values
data "azurerm_key_vault_key" "example" {
  for_each     = toset(values(local.key_map))  # Loop through each actual Key Vault key name
  name         = each.value
  key_vault_id = data.azurerm_key_vault.example.id
}

# Step 4: Output to verify the custom key-value map
output "all_keys_custom_map" {
  value = local.key_values  # This will show all keys in the custom map format
}

# Step 5: Example of accessing a specific custom key
output "dbfs_dev_key" {
  value = local.key_values["dbfs_dev_key"]  # Access the value of the dbfs-dev key using custom key
}