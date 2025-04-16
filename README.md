# 🚀 Jenkins on AWS with Terraform and Automation Scripts

Welcome to the **Jenkins AWS Automation Project**! This project provisions an EC2 instance on AWS using **Terraform** and sets up **Jenkins** automatically using a custom **Bash script**. It is designed to be beginner-friendly, modular, and practical for real-world DevOps learning.

---

## 📁 Project Structure

```
jenkins_aws/
├── main.tf                  # Terraform infrastructure definitions
├── variables.tf             # Variable declarations
├── terraform.tfvars         # Actual values for the declared variables
├── provider.tf              # AWS provider configuration
├── data.tf                  # Data source to fetch the Ubuntu AMI
├── executable/              # Local scripts to be copied to EC2
│   ├── jenkins.sh           # Installs Jenkins on the remote EC2 instance
│   ├── star.sh              # Executes all scripts in the executable/ directory
│   └── git.sh               # Installs Git if not present on the remote EC2
├── automation_script.sh     # SSH + SCP-based file automation to EC2
├── README.md                # Project documentation (this file)
```

---

## 🌐 Infrastructure Provisioning with Terraform

This project uses **Terraform** to create:

- A custom VPC with a public subnet
- An Internet Gateway and route table
- A security group allowing SSH (port 22) and Jenkins (port 8080)
- An EC2 instance (Ubuntu 22.04)
- A key pair for SSH access

### ✅ Usage

```bash
terraform init
terraform plan
terraform apply
```

You can destroy the environment with:

```bash
terraform destroy
```

---

## 🧠 Automation Script: `automation_script.sh`

This script:

- Reads EC2 public IP from Terraform output
- Determines the correct SSH user (based on OS)
- Creates a remote `Scripts/` directory
- Copies files from your local `executable/` folder to the EC2 instance
- Gives interactive options to:
  - Replace all files
  - Update a specific file
  - Remove a file from EC2

Once the files are copied to your remote EC2 instance, you should **run the ********`star.sh`******** script**. It will automatically:

- Give execute permission to all other `.sh` files
- Run them one by one in sequence

Run `automation_script.sh` locally using:

```bash
bash automation_script.sh
```

Then SSH into your EC2 instance and run:

```bash
bash ~/Scripts/star.sh
```

---

## ⚙️ Jenkins Installation Script: `jenkins.sh`

Located inside the `executable/` folder, this script:

- Detects whether the system uses `apt` or `yum`
- Installs required dependencies (Java 17, Jenkins repo, Jenkins)
- Starts and enables Jenkins service

Test it manually or let `star.sh` run it automatically on the EC2 instance.

---

## 🌀 Script Runner: `star.sh`

This utility script looks inside the `executable/` directory and:

- Makes each script executable
- Skips itself to avoid recursion
- Executes all valid `.sh` files

---

## 🛠 Git Installer: `git.sh`

This script checks if Git is installed on the remote EC2 instance and installs it if missing. It ensures version control support for additional scripting or bootstrapping.

---

## 🔐 Security Notes

- The current setup allows **open SSH access (********`0.0.0.0/0`********)** — this should be restricted in production.
- Your key pair should be secured (`~/.ssh/id_rsa`).
- Add the following to `.gitignore` to prevent pushing sensitive files:

```
.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl
*.pem
```

---

## 🧰 Requirements

- Terraform v1.0+
- AWS CLI configured (`aws configure`)
- SSH key pair generated (`~/.ssh/id_rsa`)
- Git (optional for version control)

---

## 🙋‍♂️ Author

**Sanket Salve**\
DevOps Enthusiast | Cloud Learner\
[GitHub Profile](https://github.com/SalveSanket)

---

## 📬 Feedback & Contributions

Feel free to open issues or PRs to improve this project. It’s built for learning, so contributions are always welcome!

