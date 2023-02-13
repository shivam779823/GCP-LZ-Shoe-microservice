

#Required variable--------------------------

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type = string 
}

variable "project_id" {
  description = "The ID to give the project. If not provided, the `name` will be used."
}

variable "org_id" {
  description = "organization id"
  
}

variable "billing_account" {
  description = "billing account for project"

}

variable "name" {
  description = "The name for the project"
  type        = string
}

#Optional Variables----------------------------

variable "auto_create_network" {
  description = "defualt network create in project yes or no"
  type = bool  
  default = false
}

variable "labels" {
  description = "project lables"
}
variable "use_random_id" {
  description = "use random id for temporary project id"
  type = bool
  default = false
}

variable "random_project_id_length" {
  description = "Sets the length of `random_project_id`"
  type        = number
  default     = 6
}
