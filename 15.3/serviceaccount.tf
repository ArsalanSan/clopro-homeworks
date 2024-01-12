
## Create SA
resource "yandex_iam_service_account" "sa-s3" {
  folder_id = var.folder_id
  name      = "sa-storage"
}

## Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-storage-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-s3.id}"
}

## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-s3.id
  description        = "static access key for object storage"
}