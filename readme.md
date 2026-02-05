# Infrastructure as Code 專案

這是一個使用 Terraform 和 Ansible 實現基礎設施即代碼 (IaC) 的專案，部署在 Google Cloud Platform (GCP) 上。

## 架構概覽

```
InfraAsCode/
├── terraform/          # 基礎設施定義
├── ansible/            # 配置管理
├── docker/             # Ansible Docker 化
└── readme.md           # 本文件
```

---

## 🏗️ Terraform

Terraform 負責創建和管理 GCP 上的基礎設施資源。

### 檔案架構

```
terraform/
├── main.tf             # 主要資源定義
├── provider.tf         # GCP 提供者配置
├── variables.tf        # 變數定義
├── terraform.tfvars    # 變數值 (敏感資訊，已 gitignore)
├── terraform_key       # SSH 私鑰
├── terraform_key.pub   # SSH 公鑰
├── terraform.tfstate   # 狀態檔案
└── terraform.tfstate.backup
```

### 功能說明

#### **main.tf**
- **VM 實例**: 創建 3 台 GCP Compute Engine 虛擬機器
  - `vm1`: Web 伺服器 (預設: default-vm)
  - `vm2`: Web 伺服器 (預設: default-vm)  
  - `vm3`: 資料庫伺服器 (預設: db)
- **防火牆規則**: 允許 SSH (端口 22) 從外部存取
- **SSH 金鑰管理**: 自動配置 SSH 公鑰到所有 VM

#### **provider.tf**
- 配置 GCP 提供者
- 使用服務帳號金鑰進行認證
- 設定專案 ID、區域和可用區

#### **variables.tf**
定義所有可配置的變數：
- `project_id`: GCP 專案 ID
- `region`: 部署區域 (預設: asia-east1)
- `zone`: 可用區 (預設: asia-east1-b)
- `vm1`, `vm2`, `vm3`: 各 VM 的詳細設定 (名稱、規格、映像檔、標籤)

### 主要特性

- **自動化部署**: 一鍵創建完整的 GCP 基礎設施
- **模組化設計**: 使用變數實現環境客製化
- **標籤管理**: 統一的資源標籤策略 (env, role, team)
- **安全性**: SSH 金鑰管理和防火牆控制

---

## ⚙️ Ansible

Ansible 負責對 Terraform 創建的 VM 進行配置管理和軟體部署。

### 檔案架構

```
ansible/
├── ansible.cfg                    # Ansible 配置檔案
├── inventory/                     # 主機清單
│   ├── gcp_inventory.gcp_compute.yml  # GCP 動態清單
│   └── host_vars/                 # 主機變數
│       ├── nginx.yaml
│       ├── backend.yaml
│       ├── db.yaml
│       └── terraform_key
├── playbooks/                     # 劇本檔案
│   ├── install_docker.yml         # Docker 安裝劇本
│   └── install_nginx.yml          # Nginx 部署劇本
└── group_vars/                    # 群組變數 (目錄存在)
```

### 功能說明

#### **配置檔案**

**ansible.cfg**
- 設定 GCP 動態清單插件
- 禁用主機金鑰檢查 (簡化開發)

**inventory/gcp_inventory.gcp_compute.yml**
- 使用 GCP Compute Engine 動態清單插件
- 自動發現 GCP 上的 VM
- 根據標籤自動分組 (env, role)
- 配置 SSH 連線參數

#### **劇本 (Playbooks)**

**install_docker.yml**
- **目標主機**: 所有開發環境主機 (`_env_dev`)
- **功能**: 
  - 清理舊的 Docker 套件來源
  - 安裝 Docker CE、CLI、Compose 等組件
  - 自動偵測系統 (Debian/Ubuntu) 並安裝對應版本
  - 將使用者加入 docker 群組
  - 啟動並啟用 Docker 服務

**install_nginx.yml**
- **目標主機**: Web 伺服器 (`_role_webserver`)
- **功能**:
  - 下載 Nginx Docker 映像檔
  - 使用 Docker Compose 啟動 Nginx 容器
  - 部署在 `/home/terraform2026/app` 目錄

#### **主機變數**

**host_vars/nginx.yaml**
- 設定 SSH 使用者為 `terraform`
- 指定 SSH 私鑰路徑

### 主要特性

- **動態發現**: 自動偵測 GCP 上的資源
- **標籤分組**: 根據 Terraform 設定的標籤自動分組
- **跨平台支援**: 自動適應 Debian/Ubuntu 系統
- **容器化部署**: 使用 Docker 和 Docker Compose 進行應用部署

---

## 🐳 Docker 化 Ansible

專案包含 Ansible 的 Docker 化配置，便於在不同環境中執行：

```
docker/
├── ansible/
│   ├── Dockerfile           # Ansible 容器定義
│   └── requirements.txt     # Python 依賴
└── docker-compose.yaml      # 容器編排
```

---

## 🚀 使用流程

1. **基礎設施部署**:
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

2. **配置管理**:
   ```bash
   cd ansible
   ansible-playbook playbooks/install_docker.yml
   ansible-playbook playbooks/install_nginx.yml
   ```

3. **Docker 化執行** (可選):
   ```bash
   cd docker
   docker-compose up
   ```

---

## 📋 系統架構

```
GCP Project: infraascode-486507
├── VM 1: Web Server (default-vm)
├── VM 2: Web Server (default-vm)  
└── VM 3: Database (db)

所有 VM 配置:
- 區域: asia-east1-b
- 映像: debian-cloud/debian-11
- 規格: e2-micro
- SSH: terraform 使用者
- 防火牆: 允許 SSH (22)
```

---

## 🔧 安全考量

- SSH 金鑰管理，避免密碼認證
- 防火牆規則限制存取來源
- 敏感資訊檔案已加入 .gitignore
- 使用服務帳號進行 GCP 認證

---

## 📝 注意事項

- `terraform.tfvars` 包含敏感資訊，已加入 .gitignore
- SSH 金鑰檔案需要適當的權限設定
- 防火牆規則目前允許全球存取，生產環境建議限制 IP 範圍
- Docker Compose 檔案路徑需確保存在於目標主機上