
## Create SA
resource "yandex_iam_service_account" "sa-k8s" {
  folder_id = var.folder_id
  name      = "sa-k8s"
}

## Grant permissions
# resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
#   folder_id = var.folder_id
#   role      = "editor"
#   member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
# }

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-privat-admin" {
  folder_id = var.folder_id
  role      = "vpc.privateAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-user" {
  folder_id = var.folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
