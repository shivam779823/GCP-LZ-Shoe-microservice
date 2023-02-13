variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = false
}

variable "project_id" {
  description = "Host project id"
}

variable "service_project_id" {
  type = list(string)
  description = "service project id lists"
  default = []
}
