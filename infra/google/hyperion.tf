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
  tags {
    Name = "hyperion-master"
  }
  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      nat_ip = "${google_compute_address.hyperion-master.address}"
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get install -y python2.7"
    ]
  }
}

resource "google_compute_instance" "hyperion-nodes" {
  count = "${var.hyperion_nb_nodes}"
  zone = "${var.gce_zone}"
  name = "hyperion-node-${count.index}" // => `hyperion-node-{0,1,2}`
  description = "Hyperion node ${count.index}"
  tags = ["hyperion"]
  machine_type = "${var.gce_machine_type_node}"
  tags {
    Name = "hyperion-nodes-${count.index}"
  }
  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      // ephemeral ip
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get install -y python2.7"
    ]
  }
}
