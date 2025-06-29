output "client_configuration" {
  value     = module.talos.client_configuration
  sensitive = true
}

output "kube_config" {
  value     = module.talos.kube_config
  sensitive = true
}

output "machine_config" {
  value     = module.talos.machine_config
  sensitive = true
}