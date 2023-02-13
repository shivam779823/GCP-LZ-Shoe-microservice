output "firewall" {
  description = "Firewall rule configuration"
  value = {
    description = google_compute_firewall.ingress_compute_firewall.description
    direction   = google_compute_firewall.ingress_compute_firewall.direction
    disabled    = google_compute_firewall.ingress_compute_firewall.disabled
    id          = google_compute_firewall.ingress_compute_firewall.id
    name        = google_compute_firewall.ingress_compute_firewall.name
    priority    = google_compute_firewall.ingress_compute_firewall.priority
    self_link   = google_compute_firewall.ingress_compute_firewall.self_link
  }
}

output "logging" {
  description = "GCP Logging configuration"
  value = {
    enabled = var.logging_enabled
  }
}

output "network" {
  description = "GCP Network configuration"
  value = {
    self_link = google_compute_firewall.ingress_compute_firewall.network
  }
}


