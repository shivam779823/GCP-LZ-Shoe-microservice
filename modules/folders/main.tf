###############################################################################
# Folder Module
# -----------------------------------------------------------------------------
# main.tf
###############################################################################

locals {
  folders_list = [for name in var.names : google_folder.folders[name]]
  first_folder = local.folders_list[0]
  
}

#Folder Creation

resource "google_folder" "folders" {
  for_each = toset(var.names)
  display_name = "${each.value}"
  parent       = var.parent       
}
