

output "bucket" {
  description = "The created storage bucket"
  value       = google_storage_bucket.state-bucket
}

output "name" {
  description = "Bucket name."
  value       = google_storage_bucket.state-bucket.name
}

output "url" {
  description = "Bucket URL."
  value       = google_storage_bucket.state-bucket.url
}