output "master_public_ip" {
  value = "${digitalocean_droplet.mercury-master.*.ipv4_address}"
}

output "worker_public_ip" {
  value = "${digitalocean_droplet.mercury-worker.*.ipv4_address}"
}
