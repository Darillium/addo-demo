###########
# BACKEND #
###########

terraform {
  backend "gcs" {
    bucket      = "addo-demo-cluster-state-store"
    prefix      = "state"
  }
}