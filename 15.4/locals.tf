locals {
  # Все подсети
  subnets = [
    { zone = var.env_network.ru_central1_a, subname = "${var.env_network.privat_name}_a", cidr = "192.168.10.0/24" },
    { zone = var.env_network.ru_central1_b, subname = "${var.env_network.privat_name}_b", cidr = "192.168.20.0/24" },
    #{ zone = var.env_network.ru_central1_c, subname = "${var.env_network.privat_name}_c", cidr = "192.168.30.0/24" },
    { zone = var.env_network.ru_central1_a, subname = "${var.env_network.public_name}_a", cidr = "172.17.10.0/24" },
    { zone = var.env_network.ru_central1_b, subname = "${var.env_network.public_name}_b", cidr = "172.17.20.0/24" },
    { zone = var.env_network.ru_central1_c, subname = "${var.env_network.public_name}_c", cidr = "172.17.30.0/24" }
  ]

  # Функции разделения подсетей на id
  privat_id = [ for k, v in module.vpc.subnets_locations : v if startswith(k,"privat") ]
  public_id = [ for k, v in module.vpc.subnets_locations : v if startswith(k,"public") ]
  
  # Создаем карту зонами с привязкой id 
  map_privat = zipmap([ var.env_network.ru_central1_a,var.env_network.ru_central1_b ], local.privat_id)
  map_public = zipmap([ var.env_network.ru_central1_a,var.env_network.ru_central1_b,var.env_network.ru_central1_c ], local.public_id)
}
