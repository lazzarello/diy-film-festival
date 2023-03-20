terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("keys/legal-content-381103-48fce6356492.json")

  project = "legal-content-381103"
  region  = "us-west1"
  zone    = "us-west1-b"
}

resource "google_compute_network" "vpc_network" {
  name                    = "legal-content-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "legal-content-subnetwork"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_address" "streaming_relay" {
  address_type = "EXTERNAL"
  description  = "The source proxy for streams"
  name         = "streaming-relay"
  network_tier = "STANDARD"
}

resource "google_compute_address" "streaming_broadcast" {
  address_type = "EXTERNAL"
  description  = "the single broadcast endpoint that serves DASH/HLS"
  name         = "streaming-broadcast"
  network_tier = "STANDARD"
}

resource "google_dns_managed_zone" "legalcontent" {
  description   = "live streaming legal content"
  dns_name      = "legalcontent.live."
  force_destroy = false
  name          = "legalcontent"
  visibility    = "public"
}

resource "google_dns_record_set" "streaming_broadcast" {
  name = "streaming.${google_dns_managed_zone.legalcontent.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.legalcontent.name

  rrdatas = [google_compute_instance.streaming_broadcast.network_interface[0].access_config[0].nat_ip]
}

resource "google_compute_instance" "streaming_relay" {
  boot_disk {
    auto_delete = true
    device_name = "streaming-relay"

    initialize_params {
      image = "https://www.googleapis.com/compute/beta/projects/debian-cloud/global/images/debian-11-bullseye-v20230206"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  machine_type = "e2-micro"

  metadata = {
    ssh-keys = "lazzarello:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO/c2/SsCsz3jqgoM57p9lGYDMldkn9BZwjJboM42rmC2cc35T+atKLK0w4IZGgYq5z6SeTuvi17luJt2m4+LBkBDtfWPlqDUmZb0qqrCPcRV39+AEj6pKY+4M3zTYrNvF8NqJ1bkjhX4sn4X6vtzpjKKbwVvhX4mGnevja0pMEZfkMqAbm38mIgcHXnYhpb+Sdyt6Yrbw8WD0Fja4Qf6NngJVvTa6l6WwLiCE6DCkfTuwZZT2SlL5/zwLnj9mTHOnDWo6XrdEUFJtjXhoipwAeFVemmWStQDFK/CVWlTwvRfcKWAXxLu+tsXMK6LpNG0aoEyCmbMV4TLPBmgY/hy+er3f1E9PWDDILeuy7aRJIAK6atF8P+4DeZjobdiGdPMHxglo9S0ux6p/ER1hbjFEM0elJeYSEqMR6VoVTfzMxXQqVHhgIfqXXWsDh/8ivFUZVoH4yCm1b04yNOHlPl3TsFxCDvtsCcWyUc23Yqi5uZNYHIMw2iX8TCr8lj5Vh7cs5TvPTBJYTjBOASDx1CWMsZQWp2KbNw5by0dsSWDeNtX1uqqajEf1pNtoh4s38Ji7aUUujZTWuydHA085JvLAi3lkkLrm1oSPLusad9DLZKRy/D69LIQnmdrDXV4U9Sm2uJFHwiIw29CSXKaH3k7l3BiaFFh07oVrh0YdHkO31w== lazzarello@strop.local"
  }

  name = "streaming-relay"

  network_interface {
    access_config {
      nat_ip       = google_compute_address.streaming_relay.address
      network_tier = "STANDARD"
    }

    network_ip         = "10.0.1.8"
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.default.id
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  tags = ["ssh", "http-server", "rtmp-server"]
  zone = "us-west1-b"
}

resource "google_compute_instance" "streaming_broadcast" {
  boot_disk {
    auto_delete = true
    device_name = "streaming-broadcast"

    initialize_params {
      image = "https://www.googleapis.com/compute/beta/projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230125"
      size  = 10
      type  = "pd-standard"
    }

    mode   = "READ_WRITE"
  }

  machine_type = "e2-small"

  metadata = {
    ssh-keys = "lazzarello:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO/c2/SsCsz3jqgoM57p9lGYDMldkn9BZwjJboM42rmC2cc35T+atKLK0w4IZGgYq5z6SeTuvi17luJt2m4+LBkBDtfWPlqDUmZb0qqrCPcRV39+AEj6pKY+4M3zTYrNvF8NqJ1bkjhX4sn4X6vtzpjKKbwVvhX4mGnevja0pMEZfkMqAbm38mIgcHXnYhpb+Sdyt6Yrbw8WD0Fja4Qf6NngJVvTa6l6WwLiCE6DCkfTuwZZT2SlL5/zwLnj9mTHOnDWo6XrdEUFJtjXhoipwAeFVemmWStQDFK/CVWlTwvRfcKWAXxLu+tsXMK6LpNG0aoEyCmbMV4TLPBmgY/hy+er3f1E9PWDDILeuy7aRJIAK6atF8P+4DeZjobdiGdPMHxglo9S0ux6p/ER1hbjFEM0elJeYSEqMR6VoVTfzMxXQqVHhgIfqXXWsDh/8ivFUZVoH4yCm1b04yNOHlPl3TsFxCDvtsCcWyUc23Yqi5uZNYHIMw2iX8TCr8lj5Vh7cs5TvPTBJYTjBOASDx1CWMsZQWp2KbNw5by0dsSWDeNtX1uqqajEf1pNtoh4s38Ji7aUUujZTWuydHA085JvLAi3lkkLrm1oSPLusad9DLZKRy/D69LIQnmdrDXV4U9Sm2uJFHwiIw29CSXKaH3k7l3BiaFFh07oVrh0YdHkO31w== lazzarello@strop.local"
  }

  name = "streaming-broadcast"

  network_interface {
    access_config {
      nat_ip       = google_compute_address.streaming_broadcast.address
      network_tier = "STANDARD"
    }

    network_ip         = "10.0.1.9"
    nic_type           = "GVNIC"
    stack_type         = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.default.id
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  tags = ["ssh", "dash-hls", "http-server", "https-server", "rtmp-server"]
}

resource "google_compute_firewall" "rtmp_server" {
  allow {
    ports    = ["1935"]
    protocol = "tcp"
  }

  description   = "Allow incoming RTMP from all, passing IP based authentication to nginx configuration for static IP accept lists"
  direction     = "INGRESS"
  name          = "rtmp-server"
  network = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rtmp-server"]
}

resource "google_compute_firewall" "owncast" {
  allow {
    ports    = ["8080"]
    protocol = "tcp"
  }

  description   = "tcp port 8080"
  direction     = "INGRESS"
  name          = "owncast"
  network = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["owncast"]
}

resource "google_compute_firewall" "dash_hls" {
  allow {
    ports    = ["8088"]
    protocol = "tcp"
  }

  description   = "Allow inbound DASH and HLS clients to receive video from this server"
  direction     = "INGRESS"
  name          = "dash-hls"
  network = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dash-hls"]
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports = ["22"]
    protocol = "tcp"
  }
  direction = "INGRESS"
  network = google_compute_network.vpc_network.id
  priority = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      streaming_broadcast_public = google_compute_instance.streaming_broadcast.network_interface.0.access_config.0.nat_ip
      streaming_relay_public = google_compute_instance.streaming_relay.network_interface.0.access_config.0.nat_ip
      streaming_broadcast_private = google_compute_instance.streaming_broadcast.network_interface.0.network_ip
      streaming_relay_private = google_compute_instance.streaming_broadcast.network_interface.0.network_ip
    }
  )
  filename = "../ansible/hosts.cfg"
}

output "broadcast-server-test-URL" {
 value = join("",["http://",google_compute_instance.streaming_broadcast.network_interface.0.access_config.0.nat_ip,":8088"])
}

output "broadcast-server-SSH" {
 value = join("",["ssh lazzarello@",google_compute_instance.streaming_broadcast.network_interface.0.access_config.0.nat_ip,])
}

output "broadcast-relay-SSH" {
 value = join("",["ssh lazzarello@",google_compute_instance.streaming_relay.network_interface.0.access_config.0.nat_ip,])
}
