output "kubernetes-api-server" {
    value = "https://${google_compute_instance.hyperion-master.network_interface.0.access_config.0.nat_ip}:6443"
}
