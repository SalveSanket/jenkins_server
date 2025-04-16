# ⚙️ Jenkins Installation Script (`jenkins.sh`)

## 🎯 Purpose

This script automates the installation of **Jenkins** on an EC2 instance running either **Ubuntu/Debian** or **Amazon Linux/CentOS**. It also installs **Java 17**, sets up the Jenkins repository securely, and ensures the Jenkins service is enabled and running.

---

## 🔧 What the Script Does

1. **Detects the OS Package Manager**
   - Uses `yum` for Amazon Linux/CentOS
   - Uses `apt` for Ubuntu/Debian

2. **Updates System Packages**
   - Runs `yum update -y` or `apt update && apt upgrade -y`

3. **Adds Jenkins Repository & Imports GPG Key**
   - For `yum`: adds Jenkins repo and imports key
   - For `apt`: removes outdated key (if present), adds the 2023 Jenkins GPG key securely using `signed-by` keyring

4. **Installs Java 17**
   - Uses Amazon Corretto (yum)
   - Uses OpenJDK (apt)

5. **Installs Jenkins**
   - Executes the proper install command based on package manager

6. **Enables Jenkins to Start at Boot**
   - `sudo systemctl enable jenkins`

7. **Starts Jenkins and Shows Status**
   - Uses `systemctl` to start and display service info

8. **Displays Access URL**
   - Mentions that Jenkins will be available at `http://<EC2_PUBLIC_IP>:8080`

---

## 🧪 How to Use

Once the file is on your EC2 instance (copied using `automation_script.sh`):

```bash
cd ~/Scripts
bash jenkins.sh
```

> Make sure the script has execute permissions:
```bash
chmod +x jenkins.sh
```

---

## ✅ Output Example

```
🔧 Starting Jenkins installation...
📦 Using APT (Ubuntu/Debian)
📥 Adding Jenkins repository for APT...
☕ Installing OpenJDK 17...
📦 Installing Jenkins...
🚀 Enabling Jenkins service to start at boot...
▶️ Starting Jenkins service...
📊 Checking Jenkins service status...
✅ Jenkins installation complete! Access it via your EC2 public IP on port 8080.
🔗 URL: http://<your-ec2-public-ip>:8080
```

---

## ⚠️ Notes

- Ensure port `8080` is allowed in your EC2 Security Group
- Default user is `ubuntu` (Ubuntu AMI) or `ec2-user` (Amazon Linux)
- To get the initial Jenkins password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

