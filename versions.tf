terraform {
  required_version = "~> 1.6.0" # Takes into account Terraform versions from 0.14.0
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.52.1"
    }

    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.34.0"
    }
  }
}

# Configure the OpenStack provider hosted by OVHcloud
provider "openstack" {}

provider "ovh" {
  endpoint = "ovh-eu"
}
