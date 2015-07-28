resource "openstack_compute_keypair_v2" "hyperion-key" {
  name = "${var.openstack_key_name}"
  region = "${var.openstack_region}"
  public_key = "${file("${var.openstack_public_key}")}"
}

resource "openstack_compute_secgroup_v2" "hyperion-sg" {
  region = "${var.openstack_region}"
  name = "hyperion-sg"
  description = "Security Group for Hyperion"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "udp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "tcp"
    self = true
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "udp"
    self = true
  }
  rule {
    from_port = 1
    to_port = 1
    ip_protocol = "icmp"
    self = true
  }
}

resource "openstack_networking_network_v2" "hyperion-network" {
  region = "${var.openstack_region}"
  name = "hyperion-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "hyperion-network" {
  region = "${var.openstack_region}"
  network_id = "${openstack_networking_network_v2.hyperion-network.id}"
  cidr = "${var.openstack_subnet_cidr_block}"
  ip_version = 4
}

# resource "openstack_networking_router_v2" "hyperion-network" {
#   region = "${var.openstack_region}"
#   name = "hyperion-network"
#   admin_state_up = "true"
#   external_gateway = "${var.openstack_neutron_router_gateway_network_id}"
# }

# resource "openstack_networking_router_interface_v2" "hyperion-network" {
#   region = "${var.openstack_region}"
#   router_id = "${openstack_networking_router_v2.hyperion-network.id}"
#   subnet_id = "${openstack_networking_subnet_v2.hyperion-network.id}"
# }

resource "openstack_compute_floatingip_v2" "fip-master" {
  region = "${var.openstack_region}"
  pool = "${var.openstack_floating_ip_pool_name}"
}

resource "openstack_compute_floatingip_v2" "fip-nodes" {
  count = "${var.hyperion_nb_nodes}"
  region = "${var.openstack_region}"
  pool = "${var.openstack_floating_ip_pool_name}"
}

resource "openstack_compute_instance_v2" "hyperion-master" {
  region = "${var.openstack_region}"
  name = "hyperion-master"
  image_id = "${var.openstack_image_id}"
  flavor_name = "${var.openstack_instance_type_master}"
  key_pair = "${var.openstack_key_name}"
  security_groups = ["${openstack_compute_secgroup_v2.hyperion-sg.name}"]
  network {
    uuid = "${openstack_networking_network_v2.hyperion-network.id}"
  }
  floating_ip = "${openstack_compute_floatingip_v2.fip-master.address}"
}

resource "openstack_compute_instance_v2" "hyperion-nodes" {
  count = "${var.hyperion_nb_nodes}"
  region = "${var.openstack_region}"
  name = "hyperion-node-${count.index}" // => `hyperion-node-{0,1,2}`
  image_id = "${var.openstack_image_id}"
  flavor_name = "${var.openstack_instance_type_node}"
  key_pair = "${var.openstack_key_name}"
  security_groups = ["${openstack_compute_secgroup_v2.hyperion-sg.name}"]
  network {
    uuid = "${openstack_networking_network_v2.hyperion-network.id}"
  }
  floating_ip = "${element(openstack_compute_floatingip_v2.fip-nodes.*.address, count.index)}"
}
