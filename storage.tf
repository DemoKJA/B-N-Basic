

# Create a resource groups
resource "azurerm_resource_group" "rg" {
  name     = "rg-data-ai-eastus2-${var.environment}"
  location = var.location
}


# Create user facing Storage account 
resource "azurerm_storage_account" "storageacc_user" {
  name                              = "stdataaiuser${var.environment}"
  resource_group_name               = azurerm_resource_group.rg.name
  location                          = var.location
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  account_kind                      = "StorageV2"
  is_hns_enabled                    = "true" # for datalake gen2
  enable_https_traffic_only         = "true"
  min_tls_version                   = "TLS1_0"
  infrastructure_encryption_enabled = false
  tags                              = var.tags

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  lifecycle {
    prevent_destroy = true
  }

}

# Create containers:
resource "azurerm_storage_container" "storageacc_user_client_containers" {
  for_each              = toset(var.ClientContainerNames)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storageacc_user.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.storageacc_user]
}


# Create archive Storage account 
resource "azurerm_storage_account" "storageacc_archive" {
  name                              = "stdataaiarchive${var.environment}"
  resource_group_name               = azurerm_resource_group.rg.name
  location                          = var.location
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  account_kind                      = "StorageV2"
  is_hns_enabled                    = "true" # for datalake gen2
  enable_https_traffic_only         = "true"
  min_tls_version                   = "TLS1_0"
  infrastructure_encryption_enabled = false
  tags                              = var.tags

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  lifecycle {
    prevent_destroy = true
  }

}

# Create containers:
resource "azurerm_storage_container" "storageacc_archive_client_containers" {
  for_each              = toset(var.ClientContainerNames)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storageacc_archive.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.storageacc_archive]
}