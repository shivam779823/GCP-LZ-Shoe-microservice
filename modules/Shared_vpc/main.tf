###############################################################################
# Shared Vpc Module
# -----------------------------------------------------------------------------
# main.tf
###############################################################################






#Shared VPC

locals {
  service_project_list = [for name in var.service_project_id : google_compute_shared_vpc_service_project.shared_vpc_service[name]]
}

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  project    = var.project_id
}

resource "google_compute_shared_vpc_service_project" "shared_vpc_service" {
  for_each = toset(var.service_project_id)
  host_project    = google_compute_shared_vpc_host_project.shared_vpc_host.project
  service_project = each.value
}


