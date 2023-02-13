output "template" {
  description = "Template resource."
  value       = try(google_compute_instance_template.default.0, null)
}

output "template_name" {
  description = "Template name."
  value       = try(google_compute_instance_template.default.0.name, null)
}