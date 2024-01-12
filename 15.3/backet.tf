## Create encrypted bucket
resource "yandex_storage_bucket" "s3-bucket-sec" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "arsalansan-090124"
  #max_size = 150000000

  # anonymous_access_flags {
  #   read = true
  #   list = true
  # }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-bucket.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on = [yandex_iam_service_account_static_access_key.sa-static-key]
}

## Create object and upload file
resource "yandex_storage_object" "roadmap-devops" {
  bucket = yandex_storage_bucket.s3-bucket-sec.bucket
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  key    = "devops.jpg"
  source = "./devops.jpg"
  #acl    = "public-read"

  depends_on = [yandex_storage_bucket.s3-bucket-sec]
}

## Create backet for web static
resource "yandex_storage_bucket" "static-web-demo-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "roadmap-devops-demo.ru"
  #max_size = 150000000
  #acl    = "public-read"
  anonymous_access_flags {
    read = true
    #list = true
  }

  website {
    index_document = "index.html"
  }

  https {
    certificate_id = yandex_cm_certificate.cert-roadmap-devops-demo.id
  }

  depends_on = [yandex_iam_service_account_static_access_key.sa-static-key]
}

resource "yandex_storage_object" "image-object" {
  bucket = yandex_storage_bucket.static-web-demo-bucket.bucket
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  key    = "devops.jpg"
  source = "./devops.jpg"
  #acl    = "public-read"

  #depends_on = [yandex_storage_bucket.static-web-bucket]
}

resource "yandex_storage_object" "index-object" {
  bucket = yandex_storage_bucket.static-web-demo-bucket.bucket
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  key    = "index.html"
  source = "./index.html"
  #acl    = "public-read"

  #depends_on = [yandex_storage_bucket.static-web-bucket]
}

