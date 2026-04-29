output "public_ip" {
  description = "Public IP address of the PhotoAlbum VM."
  value       = azurerm_public_ip.pip.ip_address
}

output "app_url" {
  description = "URL to access the PhotoAlbum application. Oracle takes 2–3 minutes to initialise on first boot."
  value       = "http://${azurerm_public_ip.pip.ip_address}:8080"
}

output "ssh_command" {
  description = "SSH command to connect to the VM (use the password you set in terraform.tfvars)."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}

output "setup_status" {
  description = "cloud-init runs setup.sh at first boot. Allow 5–10 minutes for Docker, the app build, and Oracle initialisation."
  value       = "Visit http://${azurerm_public_ip.pip.ip_address}:8080 after ~10 minutes. SSH in and run 'sudo docker compose -f /opt/photoalbum/docker-compose.yml ps' to check container status."
}
