nodes = {
  "talos-ctrl-1" = {
    machine_type = "controlplane"
    ip           = "192.168.88.200"
    mac_address  = "e6:ae:2e:1e:b4:4e"
    cpu          = 2
    memory       = 2048
    disk_size    = 53687091200 # 50 GB
  }
  "talos-work-1" = {
    machine_type = "worker"
    ip           = "192.168.88.201"
    mac_address  = "aa:4f:3b:38:d7:7a"
    cpu          = 4
    memory       = 8192
    disk_size    = 1100585369600 # 1 TB
  }
  "talos-work-2" = {
    machine_type = "worker"
    ip           = "192.168.88.202"
    mac_address  = "1a:79:e6:90:d5:c0"
    cpu          = 4
    memory       = 8192
    disk_size    = 1100585369600 # 1 TB
  }
}