provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "KeepRunning"                    = "true"
      "provisioner"                    = "terraform"
      "kubernetes.io/cluster/aws-rke2" = "shared"
    }
  }
}
variable "prefix" {
  type        = string
  default     = "rke2-cluster"
  description = "(Optional) The prefix to use for the resources."
}


variable "domain" {
  type        = string
  default     = ""
  description = "(Required) The domain to use for the cluster(s)"
}