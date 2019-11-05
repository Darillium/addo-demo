#######
# VPC #
#######

resource "google_compute_network" "main" {
  name                    = "${var.deployment_name}"
  auto_create_subnetworks = "false"
}
##########
# SUBNET #
##########

resource "google_compute_subnetwork" "main" {
  name                     = "${var.deployment_name}"
  ip_cidr_range            = "10.240.0.0/24"
  region                   = "${var.location}"
  network                  = "${google_compute_network.main.name}"
  private_ip_google_access = true
}


###########
# CLUSTER #
###########

resource "google_container_cluster" "main" {

  name                     = "${var.deployment_name}"
  location                 = "${var.location}"
  node_locations           = "${var.node_locations}"
  min_master_version       = "latest"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = "${google_compute_network.main.name}"
  subnetwork               = "${google_compute_subnetwork.main.name}"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "00:00"
    }
  }

  lifecycle {
    ignore_changes = ["node_config"]
  }
  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  node_config {
    image_type = "ubuntu"
    service_account = "${var.deployment_name}@${var.project_name}.iam.gserviceaccount.com"
  }
}

#############
# NODE POOL #
#############

resource "google_container_node_pool" "main" {
  name       = "${var.deployment_name}"
  cluster    = "${google_container_cluster.main.name}"
  location   = "${var.location}"
  node_count = "1"

  autoscaling  {
    min_node_count = "1"
    max_node_count = "2"
  }

  node_config {
    oauth_scopes    = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring", "https://www.googleapis.com/auth/ndev.clouddns.readwrite", "https://www.googleapis.com/auth/cloud-platform"]
    tags            = "${var.tags}"
    disk_size_gb    = 50
    machine_type    = "${var.machine_type}"
    service_account = "${var.deployment_name}@${var.project_name}.iam.gserviceaccount.com"
    image_type      = "ubuntu" #hard coded as default
  }
}