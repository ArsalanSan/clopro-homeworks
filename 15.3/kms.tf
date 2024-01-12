resource "yandex_kms_symmetric_key" "key-bucket" {
  name              = "key-bucket"
  description       = "symmetric key for bucket"
  default_algorithm = "AES_256"
 # rotation_period   = "8760h"
}
