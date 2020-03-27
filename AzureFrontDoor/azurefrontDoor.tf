resource "azurerm_resource_group" "resourceGroup" {
  name = var.resourceGroupName
  location = var.location
}

resource "azurerm_frontdoor" "azureFrontDoor" {
  name                                         = var.azureFrontdoorName
  location                                     = azurerm_resource_group.resourceGroup.location
  resource_group_name                          = azurerm_resource_group.resourceGroup.name
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
      name                    = var.azureFrontDoorRoutingRule
      accepted_protocols      = ["Http", "Https"]
      patterns_to_match       = ["/*"]
      frontend_endpoints      = [var.azureFrontDoorFrontEndEndpointName]
      forwarding_configuration {
        forwarding_protocol   = "MatchRequest"
        backend_pool_name     = var.azureFrontDoorBackEndPoolName
      }
  }

  backend_pool_load_balancing {
    name = var.azurFrontDoorBackEndPoolLBName
  }

  backend_pool_health_probe {
    name = var.azureFrontDoorBackEndPoolHealthProbeName
  }

  backend_pool {
    name     = var.azureFrontDoorBackEndPoolName
      
    dynamic "backend" {
       for_each = var.azureFrontDoorBackEnd
          content {
          host_header = backend.value
          address     = backend.value
          http_port = 80
          https_port = 443
        }
      }

    load_balancing_name = var.azurFrontDoorBackEndPoolLBName
    health_probe_name   = var.azureFrontDoorBackEndPoolHealthProbeName
  }

  frontend_endpoint {
    name                              = var.azureFrontDoorFrontEndEndpointName
    host_name                         = var.azureFrontDoorHostName
    custom_https_provisioning_enabled = false
  }
}
