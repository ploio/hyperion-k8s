variable "hyperion_nb_nodes" {
  description = "The number of nodes."
  default = "2"
}

variable "do_token" {
  description = "Digital Ocean API token."
}

variable "do_pub_key" {
  description = "SSH public key id."
}

variable "do_pvt_key" {
  description = "Path to the SSH private key file."
}

variable "do_ssh_fingerprint" {
  description = "Fingerprint of the SSH public key file."
}

variable "do_region" {
    description = "The DO region to operate under."
    default = "nyc2"
}

variable "do_image" {
    description = "The droplet image ID or slug to base the launched instances."
    default = "ubuntu-15-04-x64"
}

variable "do_size_master" {
    description = "The DO size to use for the Hyperion master instance."
    default = "512mb"
}

variable "do_size_node" {
    description = "The DO size to use for the Hyperion node instance."
    default = "512mb"
}
