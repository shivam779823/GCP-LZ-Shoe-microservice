

# VPC varibles

#Required variable--------------------------!

variable "network_peering_name" {
  description = "The name of the network peering a -> b   or b -> a"
  type        = string
}

variable "a_network" {
  description = "The name of the local network "
  type        = string
}

variable "b_peer_network" {
  description = "The name of the network where we peer"
  type        = string
}

# Optional 
variable "a_custom_routes" {
  description = "Whether to export the custom routes to the peer network. Defaults to false"
  type        = bool
  default = false
}

variable "b_peer_custom_routes" {
  description = "Whether to export the custom routes from the peer network. Defaults to false."  
  type = bool
  default = false
}