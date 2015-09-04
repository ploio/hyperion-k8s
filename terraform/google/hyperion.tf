resource "template_file" "kubernetes" {
  filename = "../kubernetes.env"
  vars {
    api_servers = "http://${var.cluster_name}-hyperion-master.c.hyperion.internal:8080"
    etcd_servers = "http://127.0.0.1:2379"
    flannel_backend = "${var.flannel_backend}"
    flannel_network = "${var.flannel_network}"
    portal_net = "${var.portal_net}"
  }
}

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
      "sudo cat <<'EOF' > /tmp/kubernetes.env\n${template_file.kubernetes.rendered}\nEOF",
      "sudo mv /tmp/kubernetes.env /etc/kubernetes.env",
      "echo 'ETCD_NAME=${self.name}' >> /tmp/etcd.env",
      "echo 'ETCD_DATA=DIR=/var/lib/etcd' >> /tmp/etcd.env",
      "echo 'ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379' >> /tmp/etcd.env",
      "echo 'ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379' >> /tmp/etcd.env",
      "sudo mv /tmp/etcd.env /etc/etcd.env",
      "sudo mkdir -p /etc/kubernetes",
      "sudo systemctl enable etcd",
      "sudo systemctl enable flannel",
      "sudo systemctl enable docker",
      "sudo systemctl enable kube-apiserver",
      "sudo systemctl enable kube-controller-manager",
      "sudo systemctl enable kube-scheduler",
      "sudo systemctl start etcd",
      "sudo systemctl start flannel",
      "sudo systemctl start docker",
      "sudo systemctl start kube-apiserver",
      "sudo systemctl start kube-controller-manager",
      "sudo systemctl start kube-scheduler"
    ]
  }
  depends_on = [
    "template_file.kubernetes",
  ]
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
      "sudo cat <<'EOF' > /tmp/kubernetes.env\n${template_file.kubernetes.rendered}\nEOF",
      "sudo mv /tmp/kubernetes.env /etc/kubernetes.env",
      "sudo systemctl enable flannel",
      "sudo systemctl enable docker",
      "sudo systemctl enable kube-kubelet",
      "sudo systemctl enable kube-proxy",
      "sudo systemctl start flannel",
      "sudo systemctl start docker",
      "sudo systemctl start kube-kubelet",
      "sudo systemctl start kube-proxy"
    ]
  }
  depends_on = [
    "template_file.kubernetes",
  ]
}
