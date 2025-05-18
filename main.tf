terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.78.0"
    }
  }
}

provider "proxmox" {
  endpoint         = var.pm_api_url
  api_token        = var.api_token
  insecure         = true
  ssh {
    agent    = true
    username = "terraform"
  }
}

data "local_file" "ssh_public_key" {
  filename = "/home/ubuntu/.ssh/id_rsa.pub"
}

resource "proxmox_virtual_environment_vm" "k3s_node" {
  count       = var.vm_count
  name        = "${var.cluster_name}-${count.index}"
  description = "K3s node ${count.index}"
  tags        = ["k3s", "terraform"]

  node_name   = var.proxmox_node
  vm_id       = 500 + count.index # Change this for VM ID Number

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = var.cpu
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
    model         = "virtio"
    bridge        = var.network_bridge
  }

  boot_order = ["scsi0"]
}

output "k3s_node_ips" {
  value = [for vm in proxmox_virtual_environment_vm.k3s_node.vm : ipv4_addresses[0]]
}
