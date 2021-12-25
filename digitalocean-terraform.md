# DigitalOcean/Terraform


## Architektura trójwarstwowa (LB, Application/Worker, DB)

```
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}
variable "access_id" {}
variable "secret_key" {}

provider "digitalocean" {
  token = var.do_token

  spaces_access_id  = var.access_id
  spaces_secret_key = var.secret_key
}

data "digitalocean_ssh_key" "default" {
  name = "default"
}

data "http" "my_ip" {
   url = "http://checkip.amazonaws.com/"
}

locals {
  region = "fra1"
  app_droplet_size = "c-4"
  worker_droplet_size = "s-4vcpu-8gb-intel"
  db_size = "db-s-1vcpu-2gb"
}

resource "digitalocean_droplet" "app" {
  count = 2
  image = "ubuntu-20-04-x64"
  name = "app-${count.index}"
  region = local.region
  size = local.app_droplet_size
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.default.id
  ]
  monitoring = true
  tags = ["droplet_app"]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      #"sudo apt update",
      #"sudo apt install -y nginx"
    ]
  }
}

resource "digitalocean_droplet" "worker" {
  image = "ubuntu-20-04-x64"
  name = "worker"
  region = local.region
  size = local.worker_droplet_size
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.default.id
  ]
  monitoring = true

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      #"sudo apt update",
      #"sudo apt install -y nginx"
    ]
  }
}

resource "digitalocean_loadbalancer" "www-lb" {
  name = "www-lb"
  region = local.region

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.app[*].id
}

resource "digitalocean_database_cluster" "mysql" {
  name       = "example-mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = local.db_size
  region     = local.region
  node_count = 1
}

resource "digitalocean_database_firewall" "mysql-fw" {
  cluster_id = digitalocean_database_cluster.mysql.id

  rule {
    type  = "ip_addr"
    value = chomp(data.http.my_ip.body)
  }

  rule {
    type  = "tag"
    value = "droplet_app"
  }

  rule {
    type  = "droplet"
    value = digitalocean_droplet.worker.id
  }
}

resource "digitalocean_database_cluster" "redis" {
  name       = "example-redis-cluster"
  engine     = "redis"
  version    = "6"
  size       = "db-s-1vcpu-1gb"
  region     = local.region
  node_count = 1
}


resource "digitalocean_database_firewall" "redis-fw" {
  cluster_id = digitalocean_database_cluster.redis.id

  rule {
    type  = "ip_addr"
    value = chomp(data.http.my_ip.body)
  }

  rule {
    type  = "tag"
    value = "droplet_app"
  }

  rule {
    type  = "droplet"
    value = digitalocean_droplet.worker.id
  }
}

resource "digitalocean_spaces_bucket" "allspace" {
  name   = "allspace-public"
  region = local.region
  acl = "public-read"
  force_destroy = true
}

resource "digitalocean_project" "playground" {
  name        = "playground"
  description = "A project to represent development resources."
  purpose     = "Web Application"
  environment = "Development"
  resources   = concat(
    digitalocean_droplet.app[*].urn,
    [
        digitalocean_droplet.worker.urn,
        digitalocean_loadbalancer.www-lb.urn,
        digitalocean_database_cluster.mysql.urn,
        digitalocean_database_cluster.redis.urn,
        digitalocean_spaces_bucket.allspace.urn
    ]
  )
}
```
