variable "location" {
  default = "northeurope"
}

variable "admin_username" {
  default = "vinadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for both VMs"
}

variable "admin_ip" {
  description = "Your public IP address to allow access to VMs"
  default     = "<your_public_ip>"
}

