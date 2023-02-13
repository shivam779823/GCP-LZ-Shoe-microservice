
  output "project_name" {
  value = google_project.main.name
}

output "project_id" {
  value = google_project.main.id
}

output "project_number" {
  description = "Numeric identifier for the project"
  value       = google_project.main.number
}

output "project_org_id" {
  value = local.project_org_id
}

output "project_folder_id" {
  value = local.project_folder_id
}
