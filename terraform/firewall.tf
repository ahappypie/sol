resource "digitalocean_firewall" "ssh-target" {
  depends_on = [digitalocean_tag.ssh-target]
  name = "ssh-target"

  tags = ["ssh-target"]

  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["${data.http.external_ip.body}"]
  }
}

resource "digitalocean_firewall" "k8s-node" {
  depends_on = [digitalocean_tag.k8s-node]
  name = "k8s-node"

  tags = ["k8s-node"]

  inbound_rule {
    protocol = "tcp"
    port_range = "10250"
    source_tags = ["k8s-node"]
  }

  outbound_rule {
      protocol = "tcp"
      port_range = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
      protocol = "udp"
      port_range = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "k8s-worker" {
  depends_on = [digitalocean_tag.k8s-worker]
  name = "k8s-worker"

  tags = ["k8s-worker"]

  inbound_rule {
    protocol = "tcp"
    port_range = "30000-32767"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "k8s-master" {
  depends_on = [digitalocean_tag.k8s-master]
  name = "k8s-master"

  tags = ["k8s-master"]

  inbound_rule {
    protocol = "tcp"
    port_range = "6443"
    source_tags = ["k8s-node"]
    source_addresses = ["${data.http.external_ip.body}"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "2379-2380"
    source_tags = ["k8s-node"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "10251"
    source_tags = ["k8s-node"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "10252"
    source_tags = ["k8s-node"]
  }
}

resource "digitalocean_firewall" "weave-net" {
  depends_on = [digitalocean_tag.weave-net]
  name = "weave-net"

  tags = ["weave-net"]

  inbound_rule {
    protocol = "tcp"
    port_range = "6783"
    source_tags = ["weave-net"]
  }

  inbound_rule {
    protocol = "udp"
    port_range = "6783-6784"
    source_tags = ["weave-net"]
  }
}

resource "digitalocean_firewall" "prometheus-node-exporter" {
  depends_on = [digitalocean_tag.prometheus-node-exporter]
  name = "prometheus-node-exporter"

  tags = ["prometheus-node-exporter"]

  inbound_rule {
    protocol = "tcp"
    port_range = "9100"
    source_tags = ["k8s-node"]
  }
}
