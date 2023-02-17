
/*****************************************
 file : Main IAC  
 Maintainer : SHIVAM 
 *****************************************/

/*****************************************
  Organization info 
 *****************************************/

# data "google_organization" "org" {
#   organization = "organizations/id"
# }

/*****************************************
  Folders 
 *****************************************/

# module "folders" {
#   source = "./modules/folders"
#   parent = "organization/435888"
#   names = [
#    "dev"
#   ]
# }

# /*****************************************
#   projects 
#  *****************************************/

# #core projects

# module "dev" {
#   source          = "./modules/projects"
#   name            = "dev"
#   folder_id       = "folders/dev"
#   billing_account = "customer"
#   org_id          = "org_id"
#   project_id      = "dev"
#   use_random_id   = true
# }

# module "billing" {
#   source          = "./modules/projects"
#   name            = "billing"
#   folder_id       = "folders/dev"
#   billing_account = "customer"
#   org_id          = "org_id"
#   project_id      = "123-bill"
# }


/*****************************************
  IAM
 *****************************************/

# module "IAM" {
#   source = "./modules/IAM"
# }

/*****************************************
  GCS bucket (Tf.state)
 *****************************************/

module "gcs-tf" {
  source     = "../../modules/cloud_bucket"
  name       = "${var.projectid}-tf"
  project_id = var.projectid
  location   = "US"
}

/*****************************************
  VPC  and Subnet
 *****************************************/

module "main-vpc" {
  source                  = "../../modules/vpc"
  project_id              = var.projectid
  network_name            = "main-vpc"
  auto_create_subnetworks = false
}

module "subnet" {
  source       = "../../modules/subnet"
  project_id   = var.projectid
  network_name = module.main-vpc.vpc.self_link

  subnets = var.subnets

   secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "k8s-pod-range"
                ip_cidr_range = "10.48.0.0/14"
            },{
                range_name    = "k8s-service-range"
                ip_cidr_range = "10.52.0.0/20"
            }
        ]
}
depends_on = [
  module.main-vpc
]
}

/*****************************************
  Router
 *****************************************/


resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network  = module.main-vpc.vpc.self_link
  depends_on = [
    module.main-vpc
  ]
}


resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = var.subnets[0]["subnet_name"]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]

  depends_on = [
    module.subnet,
    google_compute_address.nat
  ]
}

resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

 
}

/*****************************************
  firewall
 *****************************************/

module "firewall-app" {
  source               = "../../modules/firewall"
  firewall_description = "Creates firewall for LZ"
  firewall_name        = "allow-http"
  network              = module.main-vpc.vpc.self_link
  project_id           = var.projectid
  target_tags          = ["server","backend"]
  source_ranges        = ["0.0.0.0/0"]

  rules_allow = [{
    ports    = ["8080","80","9411","30001" ,"30002","31601"]
    protocol = "tcp"
  }]
  depends_on = [
    module.main-vpc
  ]
}

module "firewall-ssh" {
  source               = "../../modules/firewall"
  firewall_description = "Creates firewall for allow vm ssh"
  firewall_name        = "main-allow-ssh"
  network              = module.main-vpc.vpc.self_link
  project_id           = var.projectid
  target_tags          = ["server", "backend"]
  source_ranges        = ["0.0.0.0/0"]

  rules_allow = [{
    ports    = ["22"]
    protocol = "tcp"
  }]
  depends_on = [
    module.main-vpc
  ]
}



/*****************************************
  GKE Cluster
 *****************************************/

resource "google_container_cluster" "primary" {
  name                     = var.cluster
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = module.main-vpc.vpc.self_link
  subnetwork               =  var.subnets[0]["subnet_name"]
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  # node_locations = [
  #   "us-central1-b"
  # ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.projectid}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  #   Jenkins use case
  #   master_authorized_networks_config {
  #     cidr_blocks {
  #       cidr_block   = "10.0.0.0/18"
  #       display_name = "private-subnet-w-jenkins"
  #     }
  #   }
}


/*****************************************
  Node Pool
 *****************************************/

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account

resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool


resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-small"

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}










