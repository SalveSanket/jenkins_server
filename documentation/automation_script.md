# 🔧 `automation_script.sh` – EC2 File Deployment Automation

## 🎯 Purpose

This script automates the deployment of local scripts to an AWS EC2 instance using SSH. It:
- Retrieves the EC2 public IP from Terraform
- Detects the EC2 OS to determine the correct SSH username
- Creates a `Scripts/` directory on the EC2 instance
- Copies local files to the remote EC2 directory
- Offers interactive options to manage remote files

---

## 🧠 How It Works – Step-by-Step

### 1. **Get EC2 Public IP**
Uses `terraform output -raw public_ip` to get the EC2 instance's IP address.

### 2. **Detect EC2 OS and Set SSH Username**
It tests usernames (`ubuntu`, `ec2-user`, etc.) to see which one works based on the OS:
- `ubuntu` for Ubuntu
- `ec2-user` for Amazon Linux
- `admin` for Debian
- `centos` for CentOS

### 3. **Create Remote Folder**
Creates `/home/<user>/Scripts/` on the EC2 instance.

### 4. **Display Local Files**
Lists all files inside the local `Scripts/` directory that are ready to be transferred.

### 5. **Check Remote Files**
Checks if the remote `Scripts/` folder is empty.

### 6. **File Transfer Logic**
- If remote folder is empty:
  - Asks user: *Do you want to copy files now?*
- If remote folder has files:
  - Presents options:
    - 🔁 Replace all files
    - ✏️  Update a specific file
    - 🗑️  Remove a specific file
    - ⏭️  Skip file operations

---

## ✅ Requirements

- ✅ Terraform project is initialized and EC2 instance is up
- ✅ Public IP is available using `terraform output`
- ✅ SSH key is available at: `~/.ssh/id_rsa`
- ✅ Your project directory has a folder: `Scripts/` (containing files to deploy)

---
