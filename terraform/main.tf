data "http" "my_ip" {
  url = "https://api.ipify.org"
}

locals {
  admin_ip = "${trimspace(data.http.my_ip.response_body)}/32"
}

resource "azurerm_resource_group" "rg" {
  name     = "Hello-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Hello-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "Hello-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "Hello-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.admin_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowJenkins"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = local.admin_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = local.admin_ip
    destination_address_prefix = "*"
  }

  security_rule {
      name                       = "AllowHTTP2"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8081"
      source_address_prefix      = local.admin_ip
      destination_address_prefix = "*"
  }
} 

module "jenkins_vm" {
  source              = "./modules/linux-vm"
  name                = "jenkins-vm-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

module "app_vm" {
  source              = "./modules/linux-vm"
  name                = "app-vm-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}
