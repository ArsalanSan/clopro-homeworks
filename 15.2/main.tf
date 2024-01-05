####----------------------------
#### Calling the vpc module ####
####----------------------------

module "vpc" {
  source   = "git::https://github.com/ArsalanSan/networks.git"
  vpc_name = var.vpc_name
  subnets  = var.subnets
  zone     = var.zone
}

## Get LAMP id
# resource "yandex_compute_image" "lamp" {
#   source_family = "lamp"
# }
data "yandex_compute_image" "lamp" {
  family = "lamp"
}

## Create SA
resource "yandex_iam_service_account" "sa-s3" {
  folder_id = var.folder_id
  name      = "sa-storage"
}

## Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-s3.id}"
}

## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-s3.id
  description        = "static access key for object storage"
}

## Instance group
resource "yandex_compute_instance_group" "ig1" {
  name                = "ig-balancer"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.sa-s3.id}"
  deletion_protection = false
  instance_template {
    platform_id = var.platform_id
    resources {
      memory = 4
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      #mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.lamp.id
        type     = "network-ssd"
      }
    }
    
     network_interface {
      network_id = module.vpc.vpc_id
      subnet_ids = module.vpc.subnets_id
      #nat        = true
    }

    scheduling_policy { preemptible = true }
    metadata = {
      serial-port-enable = 1
      ssh-keys = var.ssh_key
      user-data  = "#cloud-config\n runcmd:\n - cd /var/www/html\n - echo '<html><img src=\"http://${yandex_storage_bucket.s3-bucket.bucket_domain_name}/${yandex_storage_object.roadmap-devops.key}\"/></html>' | sudo tee index.html\n - sudo systemctl restart apache2"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
    max_deleting    = 1
    max_creating    = 1
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }
  depends_on = [yandex_storage_bucket.s3-bucket]
}

## network Loadbalancer
resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
  depends_on = [yandex_compute_instance_group.ig1]
}