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

variable "zone" {
  type        = string
  description = "Name cloud zone"
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

#-----------------------------------
###### variables for networks ######
#-----------------------------------

variable "vpc_name" {
  type    = string
  default = "vpc"
}

variable "subnets" {
  description = "Create subnets"
  type = list(object(
    {
      subname     = string
      cidr        = string
    }
  ))
  default = [
    {subname = "public" , cidr = "192.168.10.0/24" },
  ]
}