## Use keys to create bucket
resource "yandex_storage_bucket" "s3-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "arsalansan-251223"
  
  anonymous_access_flags {
    read = true
    list = true
  }  
}

## Create object and upload file
resource "yandex_storage_object" "roadmap-devops" {
  bucket = yandex_storage_bucket.s3-bucket.bucket
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  key    = "devops.jpg"
  source = "./devops.jpg"
  acl    = "public-read"
}