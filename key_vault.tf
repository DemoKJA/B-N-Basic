# Create Azure key vault
resource "azurerm_key_vault" "keyvault" {
  name                     = "kv-data-ai-${var.environment}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  sku_name                 = "standard"
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = "true"
  tags                     = var.tags

  lifecycle {
    prevent_destroy = true
  }

}

