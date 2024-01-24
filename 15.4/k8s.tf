resource "yandex_kubernetes_cluster" "k8s-regional" {
  name = var.env_k8s.name
  network_id = module.vpc.vpc_id
  #release_channel = var.env_k8s.release
  #network_policy_provider = var.env_k8s.network_provider
  cluster_ipv4_range = var.env_k8s.cluster_ipv4_range
  service_ipv4_range = var.env_k8s.service_ipv4_range

  master {
    version   = var.env_k8s.version
    public_ip = true
    regional {
      region = "ru-central1"
      
      dynamic "location" {
        for_each = local.map_public
        content {
          zone      = location.key
          subnet_id = location.value
        }
      }
    }
    security_group_ids = [yandex_vpc_security_group.sg_k8s.id]
  }

  service_account_id      = yandex_iam_service_account.sa-k8s.id
  node_service_account_id = yandex_iam_service_account.sa-k8s.id
  
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter,
    yandex_resourcemanager_folder_iam_member.vpc-user,
    yandex_resourcemanager_folder_iam_member.vpc-privat-admin
  ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

resource "yandex_kubernetes_node_group" "k8s_group" {
  cluster_id  = yandex_kubernetes_cluster.k8s-regional.id
  name        = var.env_k8s.name
  description = ""
  version     = var.env_k8s.version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = ["${(local.public_id)[0]}"]
      security_group_ids = [yandex_vpc_security_group.sg_k8s.id]
    }
    
    metadata = {
        ssh-keys = var.ssh_key
    }

    resources {
      memory        = 2
      cores         = 2
      core_fraction = 5
    }

    boot_disk {
      type = "network-ssd"
      size = 30
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = var.env_network.ru_central1_a
    }
  }

#   maintenance_policy {
#     auto_upgrade = true
#     auto_repair  = true

#     maintenance_window {
#       day        = "monday"
#       start_time = "15:00"
#       duration   = "3h"
#     }

#     maintenance_window {
#       day        = "friday"
#       start_time = "10:00"
#       duration   = "4h30m"
#     }
#   }
}
