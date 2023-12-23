output "instance_ip_addresses" {
  description = "Show ip addresses"
  value       = [for vm in yandex_compute_instance.vms : vm.network_interface[0].nat ? "${vm.name} - ${vm.network_interface[0].nat_ip_address}" : "${vm.name} - ${vm.network_interface[0].ip_address} "]
}

# output "subnets_id" {
#   description = "Print subnet name and id"
#   value       = values(yandex_vpc_subnet.subnets)[*].id
# }