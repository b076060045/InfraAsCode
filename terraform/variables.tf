variable "project_id" {
  description = "GCP 專案 ID"
  type        = string
}

variable "region" {
  description = "資源部署的區域"
  type        = string
  default     = "asia-east1" # 預設台灣
}

variable "zone" {
  description = "資源部署的可用區"
  type        = string
  default     = "asia-east1-b"
}

variable "machine_type" {
  description = "VM 的規格"
  type        = string
  default     = "e2-micro"
}

variable "credentials_file" {
  description = "服務帳號金鑰路徑"
  type        = string
}

variable "vm1" {
  description = "VM 的詳細設定"
  type = object({
    name   = string
    memory = string
    image  = string
    labels = map(string)
  })
  
  # 你也可以給予預設值
  default = {
    name   = "default-vm"
    memory = "e2-micro"
    image  = "debian-cloud/debian-11"
    labels = {env="dev",role="webserver",team="devops"}
  }
}

variable "vm2" {
    description = "VM 的詳細設定"
    type = object({
        name   = string
        memory = string
        image  = string
        labels = map(string)
    })
    
    # 你也可以給予預設值
    default = {
        name   = "default-vm"
        memory = "e2-micro"
        image  = "debian-cloud/debian-11"
        labels = {env="dev",role="webserver",team="devops"}
    }
}

variable "vm3" {
    description = "DB"
    type = object(
        {
            name   = string
            memory = string
            image  = string
            labels = map(string)
        }
    )

    default = {
        name = "db",
        memory = "e2-micro",
        image = "debian-cloud/debian-11",
        labels = {env="dev",role="db",team="devops"}
    }
}