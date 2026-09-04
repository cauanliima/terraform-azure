variable "location" {
  description = "Região do Azure"
  type        = string
  default     = "eastus"
}

variable "aks_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "aks-terraform"
}

variable "aks_dns_prefix" {
  description = "Prefixo DNS do AKS"
  type        = string
  default     = "aks-terraform"
}

variable "node_vm_size" {
  description = "Tamanho das VMs dos nodes"
  type        = string
  default     = "Standard_D2ads_v7"
}

variable "node_count" {
  description = "Quantidade de nodes do AKS"
  type        = number
  default     = 2
}

variable "node_os_disk_size_gb" {
  description = "Tamanho do disco dos nodes"
  type        = number
  default     = 64
}

variable "service_cidr" {
  description = "CIDR utilizado pelos Services do Kubernetes"
  type        = string
  default     = "10.96.0.0/12"
}

variable "dns_service_ip" {
  description = "IP do DNS interno do Kubernetes"
  type        = string
  default     = "10.96.0.10"
}