resource "yandex_mdb_mysql_cluster" "_mysql-cluster_" {
  name        = var.mysql_arguments.name
  environment = var.mysql_arguments.environment
  network_id  = module.vpc.vpc_id
  version     = var.mysql_arguments.version
  
  security_group_ids  = [yandex_vpc_security_group.sg_mysql.id]
  #deletion_protection = true

  resources {
    resource_preset_id = var.mysql_arguments.preset
    disk_type_id       = var.mysql_arguments.disk_type
    disk_size          = var.mysql_arguments.disk_size
  }

  backup_window_start {
    hours = 23
    minutes = 59
  }
  backup_retain_period_days = 14

#   maintenance_window {
#     type = "WEEKLY"
#     day  = "SAT"
#     hour = 05
#   }

  dynamic "host" {                    # High-Availability(HA) 2 node
    for_each  = local.map_privat
    content{
      #name      = "host-${host.key}"
      zone      = host.key
      subnet_id = host.value
    }
  }
}

resource "yandex_mdb_mysql_database" "_netology-db_" {
  cluster_id = yandex_mdb_mysql_cluster._mysql-cluster_.id
  name       = var.env_database.db_name
}

resource "yandex_mdb_mysql_user" "_netology-db-admin_" {
  cluster_id = yandex_mdb_mysql_cluster._mysql-cluster_.id
  name       = var.env_database.name
  password   = var.env_database.password
  
  permission {
    database_name = yandex_mdb_mysql_database._netology-db_.name
    roles         = ["ALL"]
  }

#   connection_limits {
#     max_questions_per_hour   = 10
#     max_updates_per_hour     = 20
#     max_connections_per_hour = 30
#     max_user_connections     = 40
#   }

  #authentication_plugin = "SHA256_PASSWORD"
}