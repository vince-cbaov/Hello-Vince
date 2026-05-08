output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins.ip_address
}

output "app_public_ip" {
  value = azurerm_public_ip.app.ip_address
}
