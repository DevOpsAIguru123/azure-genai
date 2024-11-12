locals {
rg_name                = "RG-openAI-demo"
ai_search_name         = "ai-search-01-demo"
openai_name            = "openai-01-demo"
sa_name                = "openaisa01demo"
container_name         = "democontainer"
location               = "eastus"

  openai_deployments = [
    {
      name = "openai-gpt35turbo"
      model = {
        name    = "gpt-35-turbo"
        version = "0301"
      }
      rai_policy_name = ""
    }
  ]

}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
}


// create an openai resource service


resource "azurerm_cognitive_account" "openai" {
  name                          = "azure-openai-demo-01"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_cognitive_deployment" "deployment" {
  for_each = {for deployment in local.openai_deployments: deployment.name => deployment}

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = each.value.model.name
    version = each.value.model.version
  }
  
  sku {
    name = "Standard" // Corrected SKU name
  }
}
