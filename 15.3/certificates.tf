resource "yandex_cm_certificate" "cert-roadmap-devops-demo" {
  name    = "roadmap-devops-demo"

  self_managed {
    certificate = <<-EOT
       -----BEGIN CERTIFICATE-----
       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
       c4PI9tWbVEJ0Bg==
       -----END CERTIFICATE-----
       EOT

    private_key_lockbox_secret {
      id  = yandex_lockbox_secret.web-secret.id
      key = yandex_lockbox_secret_version.sectert-version1.entries[0].key
    }
  }
}
