terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://proxmox.local:8006/api2/json"
}

resource "proxmox_lxc" "k8s-master" {
  target_node  = "proxmox"
  hostname     = "k8s-master"
  ostemplate   = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
  unprivileged = true
  onboot = true
  start = true

  ssh_public_keys = <<-EOT
    ваш ssh ключ
  EOT

  cores = 4
  memory = 4096

  rootfs {
    storage = "local-lvm"
    size    = "20G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.56.10/24"
    gw     = "192.168.56.101"
  }
}

resource "proxmox_lxc" "k8s-worker" {
  target_node  = "proxmox"
  hostname     = "k8s-worker"
  ostemplate   = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
  unprivileged = true
  onboot = true
  start = true

  ssh_public_keys = <<-EOT
    ваш ssh ключ
  EOT

  cores = 4
  memory = 8192

  rootfs {
    storage = "local-lvm"
    size    = "20G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.56.11/24"
    gw     = "192.168.56.101"
  }
}