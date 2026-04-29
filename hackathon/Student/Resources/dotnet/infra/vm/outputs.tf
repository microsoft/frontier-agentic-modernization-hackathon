output "public_ip" {
  description = "Public IP address of the ContosoUniversity VM."
  value       = azurerm_public_ip.pip.ip_address
}

output "app_url" {
  description = "URL to access the ContosoUniversity application."
  value       = "http://${azurerm_public_ip.pip.ip_address}"
}

output "rdp_command" {
  description = "Command to open an RDP session to the VM (Windows) or mstsc shortcut."
  value       = "mstsc /v:${azurerm_public_ip.pip.ip_address}"
}

output "admin_username" {
  description = "Administrator username for RDP."
  value       = var.admin_username
}

output "setup_status" {
  description = "The custom script extension runs setup.ps1 after the VM starts. Allow 10–15 minutes for all components to install before accessing the app."
  value       = "Visit ${azurerm_public_ip.pip.ip_address} after ~15 minutes. Check extension logs in Azure Portal → VM → Extensions if the app is not reachable."
}
