variable "prefix" {
  type        = string
  description = "Short prefix used for all resource names. Keep it short (≤8 chars) and lowercase."
  default     = "wth"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources into."
  default     = "swedencentral"
}

variable "vm_size" {
  type        = string
  description = "Azure VM size. Standard_D2s_v3 (2 vCPU / 8 GB) is sufficient for IIS + SQL Express."
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  type        = string
  description = "Local administrator username for the Windows VM."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "Local administrator password. Must meet Azure complexity requirements (12+ chars, upper, lower, digit, special)."
  sensitive   = true
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group to create."
  default     = "wth-contoso-vm-rg"
}


