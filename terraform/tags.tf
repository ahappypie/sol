resource "digitalocean_tag" "ssh-target" {
  name = "ssh-target"
}

resource "digitalocean_tag" "k8s-node" {
  name = "k8s-node"
}

resource "digitalocean_tag" "k8s-worker" {
  name = "k8s-worker"
}

resource "digitalocean_tag" "k8s-master" {
  name = "k8s-master"
}

resource "digitalocean_tag" "weave-net" {
  name = "weave-net"
}

resource "digitalocean_tag" "prometheus-node-exporter" {
  name = "prometheus-node-exporter"
}
