terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.68.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
}

# tells terraform what cloud & azure provider to  interact with. 
provider "azurerm" {
  # required, inits internal provider capabilities
  # acts as a config block for az specific behavior
  features {}
}

# AZAPI resource for Image Template (since Image Builder is not yet fully supported in the azurerm provider, we use azapi to create the image template resource)
provider "azapi" {
  enable_preflight = true # optional, but recommended to catch errors before deployment
}

# define resource block
## resource "TYPE" "NAME"
resource "azurerm_resource_group" "main" { # rm - resource manager, azurerm - azure resource manager, main - name of the resource block
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# define shared image gallery resource {Destination for hardened images }
resource "azurerm_shared_image_gallery" "main" {
  name                = "sigsecureimagelab" # sig = shared image gallery
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  description         = "Gallery for secure images"
  tags                = var.tags
}

# define image type to publish to the gallery [ Blueprint for the image ]
resource "azurerm_shared_image" "ubuntu_hardened" {
  name                = "ubuntu-hardened"
  gallery_name        = azurerm_shared_image_gallery.main.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"

  identifier {
    publisher = "bic-proj"
    offer     = "secure-ubuntu"
    sku       = "baseline"
  }

  tags = var.tags
}

# User Assigned Managed Identity for Image Builder
resource "azurerm_user_assigned_identity" "image_builder" {
  name                = "id-image-builder"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags
}

# limits Contributor role to only the shared image gallery resource, follows principle of least privilege
resource "azurerm_role_assignment" "image_builder_sig" {
  scope                = azurerm_shared_image_gallery.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.image_builder.principal_id
}

# allows image builder to read from the resource group, necessary for the build process to access resources in the group
resource "azurerm_role_assignment" "image_builder_reader" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.image_builder.principal_id
}


resource "azapi_resource" "image_template" {
  type      = "Microsoft.VirtualMachineImages/imageTemplates@2021-10-01"
  name      = "imgbuilder-secure-ubuntu"
  parent_id = azurerm_resource_group.main.id
  location  = azurerm_resource_group.main.location
  tags      = var.tags

  depends_on = [azurerm_role_assignment.image_builder_sig]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.image_builder.id]
  }

  body = {
    properties = {
      buildTimeoutInMinutes = 60
      vmProfile = {
        vmSize = "Standard_D2ds_v4"
      }
      # defines the source image to be used for the build process       
      source = {
        type      = "PlatformImage"
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }
      # defines the steps to customize image
      customize = [
        {
          type = "Shell"
          name = "InstallLynis"
          inline = [
            "sudo apt-get update",
            "sudo apt-get install -y lynis"
          ]
        },
        {
          type = "Shell"
          name = "RunLynis"
          inline = [
            "sudo lynis audit system || exit 1"
          ]
        }
      ]
      # tells image builder where to publish the hardened image and what tags to apply to it in the gallery
      distribute = [
        {
          type               = "SharedImage"
          galleryImageId     = azurerm_shared_image.ubuntu_hardened.id
          runOutputName      = "secureUbuntuImage"
          replicationRegions = ["eastus"]
          artifactTags       = var.tags
        }
      ]
    }
  }
}