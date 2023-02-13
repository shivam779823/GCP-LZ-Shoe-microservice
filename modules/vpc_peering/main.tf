


###############################################################################
# VPC peering Module
# -----------------------------------------------------------------------------
# main.tf
###############################################################################

#VPC  Peering configuration



resource "google_compute_network_peering" "local_network_peering" {
  #peering a -> b   or b -> a
  name                 = var.network_peering_name
  network              = var.a_network
  peer_network         = var.b_peer_network
  export_custom_routes = var.a_custom_routes
  import_custom_routes = var.b_peer_custom_routes
}