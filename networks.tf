# Creating a private network
# only possible with the OVH provider because of the vlan_id parameter
resource "ovh_cloud_project_network_private" "network" {
  service_name = var.project_id
  name         = "demo-multiregion-network"
  regions      = var.regions

  # VLAN ID inside vRack, must be unique inside vrack, and between 0 and 4000
  vlan_id = var.vlan_id

  # Uncomment the below code if you have not already associated the project with the vRack (see vrack.tf)
  # depends_on = [ovh_vrack_cloudproject.vrack]
}

##### CREATING SUBNETS #####

# USING OVH PROVIDER

resource "ovh_cloud_project_network_private_subnet" "subnet" {
  for_each = toset(var.regions)

  region       = each.key
  service_name = var.project_id

  # ID of the ovh_cloud_network_private resource named network
  network_id = ovh_cloud_project_network_private.network.id

  # the global multi-region network CIDR, must be the same for all regions
  network = var.network_cidr # Subnet IP address location

  dhcp       = true # Enables DHCP
  no_gateway = true # No default gateway

  # start and end of the subnet, must be in the same /24 as the network CIDR,
  # the first 2 IPs are reserved for the gateway and the DHCP server,
  # must be unique for each region
  start      = cidrhost(cidrsubnet(var.network_cidr, 2, index(var.regions, each.key)), 1)
  end        = cidrhost(cidrsubnet(var.network_cidr, 2, index(var.regions, each.key)), 60)
}


# OR USING OPENSTACK PROVIDER

# resource "openstack_networking_subnet_v2" "subnet" {
#   for_each = toset(var.regions)

#   region = each.key

#   # find the openstack-specific network id from the right region
#   network_id = [for network in ovh_cloud_project_network_private.network.regions_attributes : network.openstackid if network.region == each.key][0]

#   name = lower("demo-multiregion-${each.key}")
#   ip_version = 4
#   no_gateway = true

#   # the global multi-region network CIDR, must be the same for all regions
#   cidr = var.network_cidr

#   # if you want to enable DHCP, you must specify the allocation pool
#   # else you can remove the allocation_pool block but you must assign a fixed IP to each instance
#   enable_dhcp = true
#   allocation_pool {
#     # start and end of the subnet, must be in the same /24 as the network CIDR,
#     # the first 2 IPs are reserved for the gateway and the DHCP server,
#     # must be unique for each region
#     start = cidrhost(cidrsubnet(var.network_cidr, 2, index(var.regions, each.key)), 2)
#     end   = cidrhost(cidrsubnet(var.network_cidr, 2, index(var.regions, each.key)), 60)
#   }
#   dns_nameservers = var.dns_nameservers
# }