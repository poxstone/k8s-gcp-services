variable "PROJECT_ID" {default="gcp-project-id"}
variable "PROJECT_NUMBER" {default=319417701053}

locals {
    PROJECT_ID = var.PROJECT_ID
    PROJECT_NUMBER = var.PROJECT_NUMBER
    PREFIX = "oscar-k8s"
    REGION = "us-central1"
    ZONE = "us-central1-c"
    NET_CIDR_1 = "10.2.0.0/28"
    NET_CIDR_2 = "10.10.0.0/20"
    NET_CIDR_3 = "10.20.0.0/20"
}

provider "google" {
  project     = local.PROJECT_ID
  region      = local.REGION
}

# networks
resource "google_compute_network" "net-k8s-1" {
  name                    = "${local.PREFIX}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sbnet-k8s-1" {
  name          = "${local.PREFIX}-subnetwork"
  ip_cidr_range = local.NET_CIDR_1
  network       = google_compute_network.net-k8s-1.id
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "${local.PREFIX}-secondary-pods"
    ip_cidr_range = local.NET_CIDR_2
  }
  secondary_ip_range {
    range_name    = "${local.PREFIX}-secondary-services"
    ip_cidr_range = local.NET_CIDR_3
  }
  depends_on = [google_compute_network.net-k8s-1]
}

resource "google_compute_firewall" "fw-k8s-1" {
  name    = "${local.PREFIX}-firewall"
  network = google_compute_network.net-k8s-1.name
  allow {
    protocol = "all"
  }
  #allow {}
  source_tags = []
  depends_on = [google_compute_firewall.fw-k8s-1]
}

# GKE

resource "google_container_cluster" "cluster-gk8-1" {
  name     = "${local.PREFIX}-cluster"
  location = local.ZONE
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.net-k8s-1.name
  subnetwork               = google_compute_subnetwork.sbnet-k8s-1.self_link
  #services_ipv4_cidr       = google_compute_subnetwork.sbnet-k8s-1.secondary_ip_range[0].ip_cidr_range
  depends_on = [google_compute_network.net-k8s-1]
}

data "google_service_account" "sa-default" {
  account_id   = "${local.PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
}

resource "google_container_node_pool" "nodespool-k8s-1" {
  name       = "${local.PREFIX}-node-pool"
  location   = local.ZONE
  cluster    = google_container_cluster.cluster-gk8-1.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = data.google_service_account.sa-default.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

