#------------------------------
##### variables for cloud #####
#------------------------------ 

variable "sa_key_file" {
  type        = string
  default     = "key.json"
  description = "Service account key file cloud"
}

variable "cloud_id" {
  type        = string
  description = "Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "platform_id" {
  type        = string
  description = "platform_id"
}

variable "ssh_key" {
  type        = string
  description = "ssh public key"
}

variable "custom_image" {
  type        = string
  description = "Custom image create by packer"
}

#------------------------------
### variables for resources ###
#------------------------------ 

variable "mysql_arguments" { 
  description = "MySQL cluster arguments"
  type        = map(string)
  default = {
    name          = "netology_mysql-cluster",
    environment   = "PRESTABLE",
    version       = "8.0",
    preset        = "b1.medium",
    disk_type     = "network-ssd",
    disk_size     = "20"
  }
}

variable "env_database" {
  description = "Environment database"
  type        = map(string)
  default = {
    db_name  = "",
    name     = "",
    password = ""
  }
}

variable "env_k8s" {
  description = "Environment k8s"
  type        = map(string)
  default = {
    name               = "k8s-test",
    version            = "1.25",
    release            = "STABLE",
    network_provider   = "CALICO",
    cluster_ipv4_range = "10.112.0.0/16"
    service_ipv4_range = "10.96.0.0/16"
  }
}

#-----------------------------------
###### variables for networks ######
#-----------------------------------

variable "env_network" {
  description = "Environment subnet"
  type    = map(string)
  default = {
    vpc_name      = "vpc"
    privat_name   = "privat"
    public_name   = "public"
    ru_central1_a = "ru-central1-a"
    ru_central1_b = "ru-central1-b"
    ru_central1_c = "ru-central1-c"
  }
}

#------------------------------------------
###### variables for security groups ######
#------------------------------------------

variable "sg_ingress_k8s" {
description = "rule ingress for k8s"
type = list(object(
    {
      description       = string
      protocol          = string
      v4_cidr_blocks    = optional(list(string))
      port              = optional(number)
      from_port         = optional(number)
      to_port           = optional(number)
      predefined_target = optional(string)
  }))
  default = [
    {
      description    = "The rule allows debugging ICMP packets from internal subnets"
      protocol       = "ICMP"
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description       = "The rule allows availability checks from the address range of the load balancer"
      protocol          = "TCP"
      from_port         = 0
      to_port           = 65535
      predefined_target = "loadbalancer_healthchecks"
    },
    { 
      description       = "The rule allows the master-node and node-node interaction within the security group"
      protocol          = "ANY"
      #v4_cidr_blocks    = ["172.17.10.0/24","172.17.20.0/24","172.17.30.0/24"] #"10.112.0.0/16","10.96.0.0/16",
      from_port         = 0
      to_port           = 65535
      predefined_target = "self_security_group"
    },
    {
      description    = "The rule allows the pod-pod and service-service interaction"
      protocol       = "ANY"
      v4_cidr_blocks = ["10.112.0.0/16","10.96.0.0/16"]
      from_port      = 0
      to_port        = 65535
    },
    {
      description    = "The rule allows incoming traffic from the Internet to the Node Port range"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 30000
      to_port        = 32767
    },
    {
      description    = "The rule allows connection to 80 port from the Internet"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      description    = "The rule allows connection to Kubernetes API on 443 port from the Internet"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443      
    },
    {
      description    = "The rule allows connection to Kubernetes API on 6443 port from the Internet"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 6443
    },
    {
      description    = "The rule allows connection to nodes via SSH"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    }
  ]
}

variable "sg_egress_k8s" {
description = "rule egress for k8s"
type = list(object(
    {
      description       = string
      protocol          = string
      v4_cidr_blocks    = optional(list(string))
      port              = optional(number)
      from_port         = optional(number)
      to_port           = optional(number)
  }))
  default = [
    {
      description    = "The rule allows all outgoing traffic"
      protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65535
    },
  ]
}

variable "sg_ingress_mysql" {
  description = "rules ingress for mysql"
  type = list(object(
    {
      description       = string
      protocol          = string
      v4_cidr_blocks    = optional(list(string))
      port              = optional(number)
      from_port         = optional(number)
      to_port           = optional(number)
      predefined_target = optional(string)
  }))
  default = [
    {
      description       = "The rule allows the service within the security group"
      protocol          = "ANY"
      from_port         = 0
      to_port           = 65535
      predefined_target = "self_security_group"
    },
    {
      description    = "Allow mysql port from public network"
      protocol       = "TCP"
      v4_cidr_blocks = ["172.17.10.0/24","172.17.20.0/24","172.17.30.0/24"]
      port           = 3306
    },
    {
      description    = "Allow icmp"
      protocol       = "ICMP"
      v4_cidr_blocks = ["172.17.10.0/24","172.17.20.0/24","172.17.30.0/24"]
    },
  ]
}

variable "sg_egress_mysql" {
  description = "rules egress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    { 
      description    = "Allow out any"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    },
    {
      description    = "Allow out icmp"
      protocol       = "ICMP"
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}