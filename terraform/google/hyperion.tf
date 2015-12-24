resource "template_file" "kubernetes" {
  template = "../kubernetes.env"
  vars {
    api_servers = "http://${var.cluster_name}-master.c.${var.gce_project}.internal:8080"
    etcd_servers = "http://${var.cluster_name}-master.c.${var.gce_project}.internal:4001"
    flannel_backend = "${var.flannel_backend}"
    flannel_network = "${var.flannel_network}"
    portal_net = "${var.portal_net}"
  }
}

resource "template_file" "etcd" {
    template = "../etcd.env"
    vars {
        cluster_token = "${var.cluster_name}"
    }
}

resource "google_compute_network" "hyperion-network" {
  name = "hyperion"
  ipv4_range = "${var.gce_ipv4_range}"
}

# Firewall
resource "google_compute_firewall" "hyperion-firewall-external" {
  name = "hyperion-firewall-external"
  network = "${google_compute_network.hyperion-network.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",   # SSH
      "80",   # HTTP
      "443",  # HTTPS
      "6443", # Kubernetes secured server
      "8080", # Kubernetes unsecure server
    ]
  }

}

resource "google_compute_firewall" "hyperion-firewall-internal" {
  name = "hyperion-firewall-internal"
  network = "${google_compute_network.hyperion-network.name}"
  source_ranges = ["${google_compute_network.hyperion-network.ipv4_range}"]

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }
}

resource "google_compute_address" "hyperion-master" {
  name = "hyperion-master"
}

resource "google_compute_instance" "hyperion-master" {
  zone = "${var.gce_zone}"
  name = "${var.cluster_name}-master"
  description = "Kubernetes master"
  machine_type = "${var.gce_machine_type_master}"

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
      "sudo cat <<'EOF' > /tmp/etcd.env\n${template_file.etcd.rendered}\nEOF",
      "sudo mkdir -p /etc/kubernetes",
      "sudo mv /tmp/kubernetes.env /etc/kubernetes.env",
      "sudo mv /tmp/etcd.env /etc/etcd.env",
      "echo 'ETCD_NAME=${self.name}' >> /etc/etcd.env",
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
  name = "${var.cluster_name}-node-${count.index}" // => `xxx-node-{0,1,2}`
  description = "Kubernetes node ${count.index}"
  machine_type = "${var.gce_machine_type_node}"

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
      "sudo mkdir -p /etc/kubernetes",
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
