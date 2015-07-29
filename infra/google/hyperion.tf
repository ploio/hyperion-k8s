resource "google_compute_network" "hyperion-network" {
  name = "hyperion"
  ipv4_range = "${var.gce_ipv4_range}"
}

resource "google_compute_firewall" "hyperion-network" {
  name = "hyperion"
  network = "${google_compute_network.hyperion-network.name}"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }
  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }
  target_tags = ["hyperion"]
}

resource "google_compute_address" "hyperion-master" {
  name = "hyperion-master"
}

resource "google_compute_instance" "hyperion-master" {
  zone = "${var.gce_zone}"
  name = "hyperion-master"
  tags = ["hyperion"]
  description = "Hyperion master"
  machine_type = "${var.gce_machine_type_master}"
  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      nat_ip = "${google_compute_address.hyperion-master.address}"
    }
  }
}

resource "google_compute_instance" "hyperion-nodes" {
  count = "${var.hyperion_nb_nodes}"
  zone = "${var.gce_zone}"
  name = "hyperion-node-${count.index}" // => `hyperion-node-{0,1,2}`
  description = "Hyperion node ${count.index}"
  tags = ["hyperion"]
  machine_type = "${var.gce_machine_type_node}"
  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      // ephemeral ip
    }
  }
}
