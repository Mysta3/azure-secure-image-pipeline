# tells terraform what cloud & azure provider to  interact with. 

provider "azurerm" {
  # required, inits internal provider capabilities
  # acts as a config block for az specific behavior
  features {}
}

# define resource block
## resource "TYPE" "NAME"
resource "azurerm_resource_group" "main" { # rm - resource manager, azurerm - azure resource manager, main - name of the resource block
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_shared_image_gallery" "main" {
  name                = "sigsecureimagelab" # sig = shared image gallery
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  description         = "Gallery for secure images"
  tags                = var.tags
}