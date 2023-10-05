variable "regions" {
  type    = list(string)
  default = ["DE1", "GRA9", "SBG5"]
}

variable "ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3Nza" # Replace with your SSH public key
}

variable "vrack_id" {
  type    = string
  default = "pn-XXXXXX" # Replace with your vRack ID
}

variable "project_id" {
  type    = string
  default = "OS_PROJECT_ID" # Replace with your service name / OS_PROJECT_ID value
}

variable "vlan_id" {
  type    = number
  default = 168
}

variable "network_cidr" {
  type    = string
  default = "192.168.168.0/24"
}

variable "dns_nameservers" {
  type = set(string)
  # 213.186.33.99 is the default OVH DNS server
  # 8.8.8.8 is the Google DNS server
  default = ["213.186.33.99", "8.8.8.8"]
}