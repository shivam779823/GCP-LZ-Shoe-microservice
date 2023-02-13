
#Required variable

variable "names" {
  type        = list(string)
  description = "Folder name lists"
  default     = [ ]
}

variable "parent" {
  type        = string
  description = "Resource name of parent organization or folder  organizations/1234567 or folders/869689"
}