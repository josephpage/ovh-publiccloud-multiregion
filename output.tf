output "instances" {
  value = [
    for instance in openstack_compute_instance_v2.vm :
    {
      name       = instance.name
      public_ip  = instance.access_ip_v4
      private_ip = instance.network[1].fixed_ip_v4
    }
  ]
}