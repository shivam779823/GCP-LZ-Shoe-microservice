output "shared_vpc_host" {
  value = google_compute_shared_vpc_host_project.shared_vpc_host
}

output "shared_vpc_service" {
  value = local.service_project_list
}
