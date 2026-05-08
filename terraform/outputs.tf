output "jenkins_public_ip" {
  value = module.jenkins_vm.public_ip
}

output "app_public_ip" {
  value = module.app_vm.public_ip
}
