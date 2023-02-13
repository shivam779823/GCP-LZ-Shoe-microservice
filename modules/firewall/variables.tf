# Required Variables
variable "network" {
  type        = string
  description = "The name or self link of the VPC network created in the parent module or environment. (Example: google_compute_network.vpc_network.self_link)"
}

variable "project_id" {
  type        = string
  description = "The GCP project ID (may be a alphanumeric slug) that the resources are deployed in. (Example: my-project-name)"
}

variable "firewall_description" {
  type        = string
  description = "Firewall rule description. This is a human friendly name that appears in the Cloud Console UI for administrator reference."
}

variable "firewall_name" {
  type        = string
  description = "Firewall rule name (Example: gitlab_omnibus_firewall_rule)"
}

variable "target_tags" {
  type        = list(string)
  description = "List of tags applied to Compute Engine resources that this rule will be automatically associated with."
}

# Optional Variables
variable "firewall_disabled" {
  default     = false
  type        = bool
  description = "Enables or disables the firewall rule. This is usually only used when bypassing/overruling a firewall rule temporarily or permanently without removing the configuration."
}

variable "firewall_priority" {
  default     = 1000
  type        = number
  description = "The firewall rule priority relative to other firewall rules."
}

variable "logging_enabled" {
  default     = true
  type        = bool
  description = "Enables logging to StackDriver"
}

variable "rules_allow" {
  default     = []
  description = "Firewall protocol(s) and port(s) to allow"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
}

variable "rules_deny" {
  default     = []
  description = "Firewall protocol(s) and port(s) to deny"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
}

variable "source_ranges" {
  type        = list(string)
  default     = null
  description = "List of public or internal IP CIDR ranges that traffic is coming from that this firewall rule should apply to. Either `source_ranges` or `source_tags` must have a value. For security reasons, this module is opinionated and prevents allowing 0.0.0.0/0 as a source range."
}

variable "source_tags" {
  type        = list(string)
  default     = null
  description = "List of tags applied to Compute Engine resources that traffic is coming from that this firewall rule should apply to. Either `source_ranges` or `source_tags` must have a value."
}


