variable "project_name" {
  type = "string"
  default = "darillium-dev"
}
variable "deployment_name" {
  type = "string"
  default = "addo-demo"
}

variable "location" {
  type = "string"
  default = "us-east1"
}

variable "node_locations" {
  type = "list"
  default = ["us-east1-b", "us-east1-c"]
}

variable "tags" {
  type = "list"
  default = ["addo-demo", "addo", "demo"]
}

variable "machine_type" {
  default = "n1-standard-1"
}

