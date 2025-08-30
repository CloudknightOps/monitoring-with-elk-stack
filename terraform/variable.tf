### Required Variables
variable "region" {
  type        = string
  description = "(Required) The AWS Region to use for the instance(s)."
}

variable "key_pair_name" {
  type        = string
  description = "(Required) The AWS Key Pair name to use for the instance(s)."
}

### Common Optional Variables
variable "ami_id" {
  default     = "ami-09115b7bffbe3c5e4"
  type        = string
  description = "(Optional) The AWS AMI ID to use for the instance(s)."
}
variable "ami_elk_id" {
  default = "ami-0360c520857e3138f"
  type    = string
  description = "(Optional) The AWS AMI ID to use for the ELK instance(s)."
}
variable "token" {
  default     = "awsRKE2terraform"
  type        = string
  description = "(Optional) The RKE2 Cluster Join Token to use for the cluster(s)."
}

variable "vRKE2" {
  default     = "v1.32"
  type        = string
  description = "(Optional) The RKE2 Version to use for the clusters(s)."
}

### Networking Variables
variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "(Optional) The AWS VPC CIDR Block to use for the instance(s)."
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
  type        = list(any)
  description = "(Optional) The AWS Public Subnet CIDR Blocks to use for the instance(s)."
}

### Instance Variables
variable "master_server" {
  default     = "t3.small"
  type        = string
  description = "(Optional) The AWS Instance type to use for the master node."
}

variable "agent_node" {
  default     = "t3.small"
  type        = string
  description = "(Optional) The AWS Instance type to use for the worker nodes."
}

variable "elk_node_instance_type" {
  default     = "m7i-flex.large"
  type        = string
  description = "(Optional) The AWS Instance type to use for the ELK node."
}

variable "number_of_agent_nodes" {
  default     = 2
  type        = number
  description = "(Optional) The number of AWS EC2 worker nodes to create."
}

### Storage Variables
variable "volume_size_master" {
  default     = 20
  type        = number
  description = "(Optional) The AWS Volume Size to use for the master node."
}

variable "volume_size_worker" {
  default     = 30
  type        = number
  description = "(Optional) The AWS Volume Size to use for the worker nodes."
}

variable "volume_size_elk" {
  default     = 200
  type        = number
  description = "(Optional) The AWS Volume Size to use for the ELK node."
}

variable "volume_type_master" {
  default     = "gp3"
  type        = string
  description = "(Optional) The AWS Volume Type to use for the master node."
}

variable "volume_type_worker" {
  default     = "gp3"
  type        = string
  description = "(Optional) The AWS Volume Type to use for the worker nodes."
}

variable "volume_type_elk" {
  default     = "gp3"
  type        = string
  description = "(Optional) The AWS Volume Type to use for the ELK node."
}

variable "encrypted" {
  default     = true
  type        = bool
  description = "(Optional) Whether EBS volumes should be encrypted."
}

variable "delete_on_termination" {
  default     = true
  type        = bool
  description = "(Optional) Whether to delete EBS volumes on instance termination."
}
