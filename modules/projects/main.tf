

###############################################################################
# Project Module
# -----------------------------------------------------------------------------
# main.tf
###############################################################################

#Random id generation
resource "random_id" "random_project_id_suffix" {
  byte_length = var.random_project_id_length
  lifecycle {
    create_before_destroy = true
  }
}

locals {
  base_project_id   = var.project_id == "" ? var.name : var.project_id
  project_org_id    = var.folder_id != "" ? null : var.org_id
  project_folder_id = var.folder_id != "" ? var.folder_id : null
  billing_account = var.billing_account == "" ? null : var.billing_account

  #random id (true or false)
  use_random_string = var.use_random_id
  temp_project_id=local.use_random_string ? format( "%s-%s",local.base_project_id,random_id.random_project_id_suffix.hex,): local.base_project_id  
}

#Project creation

resource "google_project" "main" {
  name                = var.name
  project_id          = var.use_random_id ? local.temp_project_id:local.base_project_id
  org_id              = local.project_org_id
  folder_id           = local.project_folder_id
  billing_account     = local.billing_account
  auto_create_network = var.auto_create_network
  labels = var.labels
}