locals {
  attached_disks = {
    for disk in var.attached_disks :
    (disk.name != null ? disk.name : disk.device_name) => merge(disk, {
      options = disk.options == null ? var.attached_disk_defaults : disk.options
    })
  }
}
resource "google_compute_instance_template" "default" {
  count            = var.create_template ? 1 : 0
  project          = var.project_id
  region           = var.region
  name_prefix      = "${var.name}-"
  description      = var.description
  tags             = var.tags
  machine_type     = var.instance_type
  min_cpu_platform = var.min_cpu_platform
  can_ip_forward   = var.can_ip_forward
  metadata         = var.metadata
  labels           = var.labels

  disk {
    auto_delete  = var.boot_disk.auto_delete
    boot         = true
    disk_size_gb = var.boot_disk.size
    disk_type    = var.boot_disk.type
    source_image = var.boot_disk.image
  }


  dynamic "disk" {
    for_each = local.attached_disks
    iterator = config
    content {
      auto_delete = config.value.options.auto_delete
      device_name = config.value.device_name != null ? config.value.device_name : config.value.name
      # Cannot use `source` with any of the fields in
      # [disk_size_gb disk_name disk_type source_image labels]
      disk_type = (
        config.value.source_type != "attach" ? config.value.options.type : null
      )
      disk_size_gb = (
        config.value.source_type != "attach" ? config.value.size : null
      )
      mode = config.value.options.mode
      source_image = (
        config.value.source_type == "image" ? config.value.source : null
      )
      source = (
        config.value.source_type == "attach" ? config.value.source : null
      )
      disk_name = (
        config.value.source_type != "attach" ? config.value.name : null
      )
      type = "PERSISTENT"
      dynamic "disk_encryption_key" {
        for_each = var.encryption != null ? [""] : []
        content {
          kms_key_self_link = var.encryption.kms_key_self_link
        }
      }
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces
    iterator = config
    content {
      network    = config.value.network
      subnetwork = config.value.subnetwork
      network_ip = try(config.value.addresses.internal, null)
      dynamic "access_config" {
        for_each = config.value.nat ? [""] : []
        content {
          nat_ip = try(config.value.addresses.external, null)
        }
      }
      dynamic "alias_ip_range" {
        for_each = config.value.alias_ips
        iterator = config_alias
        content {
          subnetwork_range_name = config_alias.key
          ip_cidr_range         = config_alias.value
        }
      }
      nic_type = config.value.nic_type
    }
  }

  scheduling {
    automatic_restart           = !var.options.spot
    # instance_termination_action = local.termination_action
    # on_host_maintenance         = local.on_host_maintenance
    preemptible                 = var.options.spot
    provisioning_model          = var.options.spot ? "SPOT" : "STANDARD"
  }

  # service_account {
  #   email  = var.service_account_email
  #   scopes = var.service_account_scopes
  # }

  dynamic "shielded_instance_config" {
    for_each = var.shielded_config != null ? [var.shielded_config] : []
    iterator = config
    content {
      enable_secure_boot          = config.value.enable_secure_boot
      enable_vtpm                 = config.value.enable_vtpm
      enable_integrity_monitoring = config.value.enable_integrity_monitoring
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
