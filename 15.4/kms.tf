resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  description       = "symmetric key"
  default_algorithm = "AES_256"
 # rotation_period   = "8760h"
}
