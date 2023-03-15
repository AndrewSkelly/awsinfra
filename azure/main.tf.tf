# provider "azurerm" {
#   features {}
# }

# variable "key_name" {}

# variable "db_username" {
#   default = "admin"
# }

# variable "db_password" {
#   default = "TUDproj23"
# }

# resource "tls_private_key" "example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "azurerm_key_vault" "example" {
#   name                       = "example-keyvault"
#   location                   = "eastus"
#   resource_group_name        = "example-resource-group"
#   tenant_id                  = data.azurerm_client_config.current.tenant_id
#   sku_name                   = "standard"
#   enabled_for_disk_encryption = true
# }

# resource "azurerm_key_vault_key" "example" {
#   name         = "example-key"
#   key_vault_id = azurerm_key_vault.example.id
#   key_type     = "RSA"
#   key_size     = 2048
# }

# resource "azurerm_linux_virtual_machine" "example" {
#   name                  = "example-vm"
#   location              = "eastus"
#   resource_group_name   = "example-resource-group"
#   size                  = "Standard_B1ms"
#   admin_username        = "exampleadmin"
#   network_interface_ids = [azurerm_network_interface.example.id]

#   admin_ssh_key {
#     username   = "exampleadmin"
#     public_key = tls_private_key.example.public_key_openssh
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   tags = {
#     environment = "dev"
#   }
# }

# resource "azurerm_network_interface" "example" {
#   name                = "example-nic"
#   location            = "eastus"
#   resource_group_name = "example-resource-group"

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.example.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_subnet" "example" {
#   name                 = "example-subnet"
#   resource_group_name  = "example-resource-group"
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_virtual_network" "example" {
#   name                = "example-vnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = "eastus"
#   resource_group_name = "example-resource-group"
# }