output "hyperion_master" {
  value = "${digitalocean_droplet.hyperion-master.ipv4_address}"
}

output "hyperion_nodes" {
  value = "${join(" - ", digitalocean_droplet.hyperion-nodes.*.ipv4_address)}"
}
