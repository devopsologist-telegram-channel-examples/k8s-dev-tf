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

resource "proxmox_vm_qemu" "k8s-master" {
  count = 1
  name  = "k8s-master"
  target_node = "proxmox"
  vmid        = "100"
  clone       = "debian12.vm"
  agent       = 1
  os_type     = "cloud-init"
  cpu         = "host"
  vcpus       = 0
  cores       = 2
  sockets     = 1
  memory      = 4096
  scsihw      = "virtio-scsi-single"
  bootdisk    = "scsi0"
  onboot = true

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size     = "20G"
          storage  = "local"
          iothread = true
        }
      }
    }
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
  }

  boot = "order=scsi0"
  ipconfig0 = "ip=192.168.0.4/24,gw=192.168.0.3"
  ciuser    = "terraform"
  sshkeys   = <<EOF
    ваш ssh ключ
  EOF
}

resource "proxmox_vm_qemu" "k8s-worker" {
  count = 1
  name  = "k8s-worker"
  target_node = "proxmox"
  vmid        = "101"
  clone       = "debian12.vm"
  agent       = 1
  os_type     = "cloud-init"
  cpu         = "host"
  vcpus       = 0
  cores       = 4
  sockets     = 1
  memory      = 8192
  scsihw      = "virtio-scsi-single"
  bootdisk    = "scsi0"
  onboot = true

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size     = "20G"
          storage  = "local"
          iothread = true
        }
      }
    }
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
  }

  boot = "order=scsi0"
  ipconfig0 = "ip=192.168.0.5/24,gw=192.168.0.3"
  ciuser    = "terraform"
  sshkeys   = <<EOF
    ваш ssh ключ
  EOF
}
