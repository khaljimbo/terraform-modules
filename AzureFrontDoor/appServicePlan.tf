locals {
  asps = flatten([
    for resource in keys(var.Regions) : [
      for asp in var.Regions[resource] : {
        resource    = resource
        name        = asp.name
        location    = asp.location
      }
    ]
  ])

  asp_map = {
    for s in local.asps: "${s.resource}:${s.location}" => s
  }
}

resource "azurerm_app_service_plan" "appServicePlan" {
  for_each = local.asp_map 
  
    name                = each.value.name
    location            = each.value.location
    resource_group_name = var.resourceGroupName
    kind                = var.kind

    sku {
      tier = var.tier
      size = var.size
    }

}
