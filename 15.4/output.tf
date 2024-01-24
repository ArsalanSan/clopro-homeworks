output "urls-mysql" {
  description = "URLs-mysql"
  value       = yandex_mdb_mysql_cluster._mysql-cluster_.host[*].fqdn
}