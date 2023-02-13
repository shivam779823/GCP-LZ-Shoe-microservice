

output "folder" {
  value       = local.first_folder
}

output "id" {
  value       = local.first_folder.name
}

output "name" {
  description = "Folder name"
  value       = local.first_folder.display_name
}

output "folders" {
  description = "Folder resources as list."
  value       = local.folders_list
}
