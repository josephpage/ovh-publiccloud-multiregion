resource "openstack_compute_keypair_v2" "key_pair" {
  for_each = toset(var.regions)

  name       = lower("demo-multiregion-${each.key}")
  public_key = var.ssh_public_key

  region = each.key
}


resource "openstack_compute_instance_v2" "vm" {
  for_each = toset(var.regions)

  name   = lower("demo-multiregion-${each.key}")
  region = each.key

  image_name      = "Ubuntu 22.04"
  flavor_name     = "d2-2"
  key_pair        = openstack_compute_keypair_v2.key_pair[each.key].name
  security_groups = ["default"]

  network {
    name = "Ext-Net" # Adds the network component to reach your instance
  }

  # Here we attach the created private network
  network {
    # When using ovh provider for the subnet
    name = ovh_cloud_project_network_private.network.name

    # When using openstack provider for the subnet
    # uuid = openstack_networking_subnet_v2.subnet[each.key].network_id
  }
}
