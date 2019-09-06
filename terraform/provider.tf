data "http" "external_ip" {
url = "http://ident.me"
}

provider "digitalocean" {
  token = ""
}

variable "master_count" {
  type = number
  default = 1
}

variable "worker_count" {
  type = number
  default = 5
}
