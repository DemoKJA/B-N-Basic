
# Create Azure Datafactory
resource "azurerm_data_factory" "adf" {
  name                = "adf-data-ai-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  identity {
    type = "SystemAssigned"
  }


  # For "branch_name", it's the branch where actual version and work is done, note the 'main' branch, 
  # which is what will be used to publich ARM template to envionrmenets in terraform.
  # *** For handling different tiers, ie. dev,stage, prod, paramterize their own branch, see below, but publish from
  # only the tier you want to then be published in terraform. If do not have different collab brnaches accross tiers,
  # then all tier, dev, stage, prod, will share a branch and any update on one will automativally be updated on all!!! 

  # As for the folder structure in 'main', it will take the 
  lifecycle {
    ignore_changes = [github_configuration]
  }

  dynamic "github_configuration" {
    for_each = var.adf_git ? [1] : []
    content {
      account_name    = "demokja"
      git_url         = "https://github.com"
      branch_name     = "main"
      repository_name = "Datafactory-BN"
      root_folder     = "/"
    }

  }
}


# role assignents

# adding ADF contributor access to user facing storage account
resource "azurerm_role_assignment" "adf_storageacc_user_contributor" {
  scope                = azurerm_storage_account.storageacc_user.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.adf.identity.0.principal_id
}

# adding ADF Storage Blob Data Contributor access to user facing storage account
resource "azurerm_role_assignment" "adf_storageacc_user_blob_data_contr" {
  scope                = azurerm_storage_account.storageacc_user.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.adf.identity.0.principal_id
}

# adding ADF contributor access to archive storage account
resource "azurerm_role_assignment" "adf_storageacc_archive_contributor" {
  scope                = azurerm_storage_account.storageacc_archive.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.adf.identity.0.principal_id
}

# adding ADF Storage Blob Data Contributor access to archive storage account
resource "azurerm_role_assignment" "adf_storageacc_archive_blob_data_contr" {
  scope                = azurerm_storage_account.storageacc_archive.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.adf.identity.0.principal_id
}


resource "azurerm_databricks_workspace" "dbw" {
  name                = "dbwdataai${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"

  custom_parameters {
    no_public_ip = "true"
  }

  lifecycle {
    prevent_destroy = true
  }
}