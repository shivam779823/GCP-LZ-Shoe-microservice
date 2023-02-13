###############################################################################
# Firewall Configuration Module
# -----------------------------------------------------------------------------
# main.tf
###############################################################################

resource "google_compute_firewall" "ingress_compute_firewall" {
  description   = var.firewall_description
  direction     = "INGRESS"
  disabled      = var.firewall_disabled
  name          = var.firewall_name
  network       = var.network
  priority      = var.firewall_priority
  project       = var.project_id
  source_ranges = var.source_ranges
  source_tags   = var.source_tags
  target_tags   = var.target_tags

  dynamic "allow" {
    for_each = var.rules_allow
    iterator = allow_rule
    content {
      ports    = allow_rule.value.ports
      protocol = allow_rule.value.protocol
    }
  }

  dynamic "deny" {
    for_each = var.rules_deny
    iterator = deny_rule
    content {
      ports    = deny_rule.value.ports
      protocol = deny_rule.value.protocol
    }
  }

  log_config {
    metadata = var.logging_enabled ? "INCLUDE_ALL_METADATA" : "EXCLUDE_ALL_METADATA"
  }
}
























