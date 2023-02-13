#Oraganization Level IAM 

resource "google_organization_iam_binding" "organization" {
  org_id  = "customer"
  role    = "roles/editor"

  members = [
    "user:Shivam@customer.com"
  ]
}

#Folder Level IAM

resource "google_folder_iam_binding" "folder" {
  folder  = "folders/core"
  role    = "roles/viewer"

  members = [
    "user:jane@example.com",
  ]
}

#Project Level IAM

resource "google_project_iam_binding" "project" {

  project = "core"
  role    = "roles/viewer"

  members = [
    "group:Shivam@customer.com",
  ]
}
resource "google_billing_account_iam_binding" "editor" {
  billing_account_id = "00AA00-000AAA-00AA0A"
  role               = "roles/billing.viewer"
  members = [
    "user:jane@example.com",
  ]
}


#Service account 

#Default account info

data "google_compute_default_service_account" "default" {
}

#COE service account 

resource "google_service_account" "service_account" {
  account_id   = "coe123"
  display_name = "COE"
}

#IAM bindings 

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.service_account.name
  role               = "role/iam.serviceAccountUser"

  members = [
    "user:Shivam@customer.com",
  ]
}


# #Allow COE service account use the default GCE account

# resource "google_service_account_iam_member" "gce-default-account-iam" {
#   service_account_id = data.google_compute_default_service_account.default.name
#   role               = "roles/iam.serviceAccountUser"
#   member             = "serviceAccount:${google_service_account.service_account.email}"
# }
