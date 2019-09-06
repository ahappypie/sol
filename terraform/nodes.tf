resource "digitalocean_droplet" "mercury-master" {
  depends_on = [digitalocean_firewall.ssh-target, digitalocean_firewall.k8s-node, digitalocean_firewall.k8s-master, digitalocean_firewall.weave-net, digitalocean_firewall.prometheus-node-exporter]
  count = var.master_count
  image  = "ubuntu-18-04-x64"
  name   = "mercury-master-${count.index}"
  region = "sfo2"
  size   = "s-2vcpu-4gb"
  backups = false
  monitoring = true
  ipv6 = false
  private_networking = true
  resize_disk = true
  ssh_keys = [****]
  tags = ["k8s-master", "k8s-node", "weave-net", "ssh-target", "prometheus-node-exporter"]
  user_data = "${file("templates/cloud-init.sh")}"
}

resource "null_resource" "mercury-master-provision" {
  depends_on = [digitalocean_droplet.mercury-master]
  count = var.master_count

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-master[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}" not working because it's password protected
      agent = true
      timeout = "5m"
    }

    on_failure = "continue"
  }

  #https://gist.github.com/janoszen/9df88ba0b906af1c18c0812a7128af7a + a little sleep
  #because of node restart. see github.com/hashicorp/terraform/issues/17844
  provisioner "local-exec" {
    command = "sleep 5 && . wait_port.sh ${digitalocean_droplet.mercury-master[count.index].ipv4_address} 22"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /var/kubeadm"
    ]

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-master[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}" not working because it's password protected
      agent = true
      timeout = "5m"
    }
  }

  provisioner "file" {
    source = "./templates/do-ccm-master.yaml"
    destination = "/var/kubeadm/do-ccm-master.yaml"

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-master[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}" not working because it's password protected
      agent = true
      timeout = "5m"
    }
  }

  provisioner "file" {
    source = "../do-cloud-controller"
    destination = "/var/kubeadm"

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-master[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}" not working because it's password protected
      agent = true
      timeout = "5m"
    }
  }

  provisioner "remote-exec" {
    script = "templates/master-init.sh"

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-master[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}"
      agent = true
      timeout = "5m"
    }
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=accept-new -i ../keys/key.rsa root@${digitalocean_droplet.mercury-master[count.index].ipv4_address}:/etc/kubernetes/admin.conf ./kube/"
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=accept-new -i ../keys/key.rsa root@${digitalocean_droplet.mercury-master[count.index].ipv4_address}:/var/kubeadm/join.sh ./kube/"
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=accept-new -i ../keys/key.rsa root@${digitalocean_droplet.mercury-master[count.index].ipv4_address}:/var/kubeadm/discovery-token-hash ./kube/"
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=accept-new -i ../keys/key.rsa root@${digitalocean_droplet.mercury-master[count.index].ipv4_address}:/var/kubeadm/auth-token ./kube/"
  }
}

resource "digitalocean_droplet" "mercury-worker" {
  depends_on = [digitalocean_firewall.ssh-target, digitalocean_firewall.k8s-node, digitalocean_firewall.k8s-worker, digitalocean_firewall.weave-net, digitalocean_firewall.prometheus-node-exporter]
  count = var.worker_count
  image  = "ubuntu-18-04-x64"
  name   = "mercury-worker-${count.index}"
  region = "sfo2"
  size   = "s-6vcpu-16gb"
  backups = false
  monitoring = true
  ipv6 = false
  private_networking = true
  resize_disk = true
  ssh_keys = [****]
  tags = ["k8s-node", "k8s-worker", "weave-net", "ssh-target", "prometheus-node-exporter"]
  user_data = "${file("templates/cloud-init.sh")}"
}

resource "null_resource" "mercury-worker-provision" {
  depends_on = [digitalocean_droplet.mercury-worker]
  count = var.worker_count
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-worker[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}" not working because it's password protected
      agent = true
      timeout = "5m"
    }

    on_failure = "continue"
  }

  #https://gist.github.com/janoszen/9df88ba0b906af1c18c0812a7128af7a + a little sleep
  #because of node restart. see github.com/hashicorp/terraform/issues/17844
  provisioner "local-exec" {
    command = "sleep 5 && . wait_port.sh ${digitalocean_droplet.mercury-worker[count.index].ipv4_address} 22"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /var/kubeadm"
    ]

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-worker[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}" not working because it's password protected
      agent = true
      timeout = "5m"
    }
  }
}

resource null_resource "mercury-worker-join" {
  depends_on = [null_resource.mercury-master-provision, null_resource.mercury-worker-provision]
  count = var.worker_count

  provisioner "local-exec" {
    command = "cat templates/do-ccm-worker.json | jq --arg id digitalocean://${digitalocean_droplet.mercury-worker[count.index].id} --arg token $(cat kube/auth-token) --arg ip ${digitalocean_droplet.mercury-master.0.ipv4_address}:6443 --arg hash sha256:$(cat kube/discovery-token-hash) '.nodeRegistration.kubeletExtraArgs[\"provider-id\"] = $id | .discovery.bootstrapToken.token = $token | .discovery.bootstrapToken.apiServerEndpoint = $ip | .discovery.bootstrapToken.caCertHashes = [$hash]' | gojsontoyaml > kube/do-ccm-worker-${count.index}.yaml"
  }

  provisioner "file" {
    source = "./kube/do-ccm-worker-${count.index}.yaml"
    destination = "/var/kubeadm/do-ccm-worker-${count.index}.yaml"

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-worker[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}" not working because it's password protected
      agent = true
      timeout = "5m"
    }
  }
  //must put a dummy file in kube/join.sh for terraform plan
  provisioner "remote-exec" {
    inline = [
      "kubeadm join --config=/var/kubeadm/do-ccm-worker-${count.index}.yaml"
    ]

    connection {
      type = "ssh"
      host = "${digitalocean_droplet.mercury-worker[count.index].ipv4_address}"
      user = "root"
      //private_key = "${file("../keys/key.rsa")}"
      agent = true
      timeout = "5m"
    }
  }
}
