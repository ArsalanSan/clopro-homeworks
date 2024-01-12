resource "yandex_lockbox_secret" "web-secret" {
  name                = "web-secret"
  description         = "secrets for web source"
  folder_id           = var.folder_id
  kms_key_id          = yandex_kms_symmetric_key.key-bucket.id
  deletion_protection = false
}

resource "yandex_lockbox_secret_version" "sectert-version1" {
  secret_id = yandex_lockbox_secret.web-secret.id
  entries {
    key        = "cert_key"
    text_value = <<-EOT
    -----BEGIN PRIVATE KEY-----
    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
    5YxDofeSld2I61RYwd1D1rk8tkocfOJWIgM3vWo+lhB4c0NYcRfgW9TV8xtGcYit
    rUr6+E7ophwA0Slv4HWEWfISON98W9XvglnWzlAS3Lc4a1qLETEYsV4vF7L/HjNy
    MTL/WkkiZ8NWcC6I9L+VPyM+ZM5yydw3Ypm8608CggEAJWvOVv4R2eUCyPXynr1R
    njfZDXvOEET4BXOQGeDmZ/OA42HN8z6Jv2HJZqbTnFDhookydZsvgls4XdozYrY2
    09AV43nOglkzrg89Luc+TN+O7cgqvtA8auYxX3rcV1I8+xHequja1S1N4SqVkA/f
    7h24dgkJalnNk01rwU+663qWLBopX8IiVi7X769mB1ONS3QxtY7aYv+XQETLePzY
    Un9Xub2ySyUiozWE2ZIkjQ4oOrQZNOVO5jTULSS8QwsDgiqA23cjDtj3NdKjcrUY
    51M961sJgopwnJZplIurrrrD9ost+lMyxbwjYWdQ6Ikuse0S5n15R4ct9Cpa3ja0
    OQKCAQEArVQwJZv2kc7IWz1Zocyz59lN3Xrrc9278JjJl3bmIp/z6Jq6RsX25uEv
    xmIB/Hrd9qBgyYDGFtbXbjy3tXDFgGwtHZ5FsLX9PqymFTGPtGhUAnLzm3/ArBtf
    YTwArba8XTY93gnV3b0z15jPGS21z4XG2dA/t6OXI4sicihZ3NoDILzVMQZHw5IJ
    TFcscxYgX+oaqnbJ38uoFdLZaG7vEnXO2p6I6N6rCtpfzxSChaSMzFgB3jHVCuaU
    0zUIQ6X0ahNKL0F38/0Yfg/2TA6+q7k5Lb++jIANKiwxyUm1taJHP+vUG6k+FECO
    GwwnMxATRJa3mAtnXAEeojLoomV7iA==
    -----END PRIVATE KEY-----
    EOT
  }
}