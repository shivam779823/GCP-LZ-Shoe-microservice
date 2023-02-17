variable "region" {
  default = "us-central1"
}

variable "projectid" {
}

variable "cluster" {
}

variable "subnets" {
  type = list(map(string))
  # default = [{
  #   subnet_name           = "subnet-01"
  #   subnet_region         = "us-central1"
  #   subnet_ip             = "10.10.20.0/24"
  #   subnet_flow_logs      = "false"
  #   subnet_private_access = "true"
  # }]
}