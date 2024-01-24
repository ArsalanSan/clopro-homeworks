resource "yandex_vpc_security_group" "sg_mysql" {
  name       = "sg_mysql"
  network_id = module.vpc.vpc_id
  
  dynamic "ingress" {
    for_each = var.sg_ingress_mysql
    content {
      description       = lookup(ingress.value, "description", null)
      protocol          = lookup(ingress.value, "protocol", null)
      port              = lookup(ingress.value, "port", null)
      from_port         = lookup(ingress.value, "from_port", null)
      to_port           = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks    = lookup(ingress.value, "v4_cidr_blocks", null)
      predefined_target = lookup(ingress.value, "predefined_target", null)
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_mysql
    content {
      description    = lookup(egress.value, "description", null)
      protocol       = lookup(egress.value, "protocol", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}

resource "yandex_vpc_security_group" "sg_k8s" {
  name       = "sg_k8s"
  network_id = module.vpc.vpc_id
  
  dynamic "ingress" {
    for_each = var.sg_ingress_k8s
    content {
      description       = lookup(ingress.value, "description", null)
      protocol          = lookup(ingress.value, "protocol", null)
      port              = lookup(ingress.value, "port", null)
      from_port         = lookup(ingress.value, "from_port", null)
      to_port           = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks    = lookup(ingress.value, "v4_cidr_blocks", null)
      predefined_target = lookup(ingress.value, "predefined_target", null)
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_k8s
    content {
      description    = lookup(egress.value, "description", null)
      protocol       = lookup(egress.value, "protocol", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}
