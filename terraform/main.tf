resource "google_compute_instance" "default" {
  name         = var.vm1.name
  machine_type = var.vm1.memory

  labels = {
    env  = var.vm1.labels.env
    role = var.vm1.labels.role
  }

  metadata = {
    ssh-keys = "terraform:${file("/terraform_key.pub")}"
  }

  boot_disk {
    initialize_params {
      image = var.vm1.image
    } # 這裡原本漏掉了
  }

  network_interface {
    network = "default"

    access_config {
      # 留空代表使用動態外部 IP
    }
  }
  tags = ["allow-ssh"]
}

resource "google_compute_instance" "default2" {
  name         = var.vm2.name
  machine_type = var.vm2.memory

  labels = {
    env  = var.vm2.labels.env
    role = var.vm2.labels.role
  }

  metadata = {
    ssh-keys = "terraform:${file("/terraform_key.pub")}"
  }

  boot_disk {
    initialize_params {
      image = var.vm2.image
    } # 這裡原本漏掉了
  }

  network_interface {
    network = "default"

    access_config {
      # 留空代表使用動態外部 IP
    }
  }
  tags = ["allow-ssh"]
}


resource "google_compute_instance" "default3" {
    name         = var.vm3.name
  machine_type = var.vm3.memory

  labels = {
    env  = var.vm3.labels.env
    role = var.vm3.labels.role
  }

  metadata = {
    ssh-keys = "terraform:${file("/terraform_key.pub")}"
  }

  boot_disk {
    initialize_params {
      image = var.vm3.image
    } # 這裡原本漏掉了
  }

  network_interface {
    network = "default"

    access_config {
      # 留空代表使用動態外部 IP
    }
  }
  tags = ["allow-ssh"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-from-internet"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # 為了安全，建議 source_ranges 填寫你家的固定 IP
  # 如果是測試，可以先用 0.0.0.0/0 (代表全世界)
  source_ranges = ["0.0.0.0/0"] 
  target_tags   = ["allow-ssh"]
}