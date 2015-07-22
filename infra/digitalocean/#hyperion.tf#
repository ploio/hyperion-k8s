 resource "digitalocean_ssh_key" "hyperion-ssh-key" {
   name = "hyperion-ssh-key"
   public_key = "${file("${var.do_pub_key}")}"
}

resource "digitalocean_droplet" "hyperion-master" {
  name = "hyperion-master"
  region = "${var.do_region}"
  image = "${var.do_image}"
  size = "${var.do_size_master}"
  private_networking = true
  ssh_keys = ["${var.do_ssh_fingerprint}"]
  depends_on = [ "digitalocean_ssh_key.hyperion-ssh-key" ]

  connection {
    key_file = "${var.do_pvt_key}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python2"
    ]
  }
}

resource "digitalocean_droplet" "hyperion-nodes" {
  count = "${var.hyperion_nb_nodes}"
  name = "hyperion-node-${count.index}" // => `hyperion-node-{0,1}`
  region = "${var.do_region}"
  image = "${var.do_image}"
  size = "${var.do_size_node}"
  private_networking = true
  ssh_keys = ["${var.do_ssh_fingerprint}"]
  depends_on = [ "digitalocean_ssh_key.hyperion-ssh-key" ]

  connection {
    key_file = "${var.do_pvt_key}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get install -y python2"
    ]
  }
}
