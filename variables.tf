variable "pm_api_url" {}
variable "api_token" {}

variable "proxmox_node"   { default = "pve03" }
variable "template_id"    { default = 9000 }  # ID of the Proxmox cloud-init template
variable "datastore"      { default = "local-lvm" }
variable "network_bridge" { default = "vmbr0" }

variable "cluster_name"   { default = "k3s" }
variable "vm_count"       { default = 3 }
variable "cpu"            { default = 2 }
variable "memory"         { default = 4098 }
variable "disk_size"      { default = "10" }

variable "ssh_key_path"   { default = "~/.ssh/id_rsa.pub" }
