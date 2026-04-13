# tells terraform what cloud & azure provider to  interact with. 

provider "azurerm" {
  # required, inits internal provider capabilities
  # acts as a config block for az specific behavior
  features {}
}

# define resource block
## resoruce "TYPE" "NAME"
resource "azurerm_resource_group" "main" {
  name        = var.resource_group_name
  location    = var.location
}