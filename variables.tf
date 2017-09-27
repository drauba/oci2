variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}

variable "ssh_public_key" {
  default = "./sshkey.pub"
}

variable "webcount" {
  default = "1"
}

variable "domain" {
  default = "dev.ct6.io"
}

variable "region" {
  default = "us-east-1"
}

variable "CidrVCN" {
  default = "172.31.0.0/16"
}

variable "CidrSubnet" {
  default = "172.31.0.0/24"
}

variable "CidrSubnet1Database" {
  default = "172.31.1.0/24"
}

variable "CidrSubnet2Shared" {
  default = "172.31.2.0/24"
}

variable "CidrSubnet3Public" {
  default = "172.31.3.0/24"
}

variable "CidrDev" {
  default = "10.0.0.0/8"
}

variable "CidrVCNSharedServices" {
  default = "172.31.5.0/24"
}

variable "CidrTrendMicroDeepScan" {
  default = "54.221.196.0/24"
}
