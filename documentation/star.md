# 🌀 Script Runner: `star.sh`

## 📋 Purpose

`star.sh` is an automation script designed to execute all scripts in the `Scripts/` directory on your EC2 instance. It ensures each script is executable and then runs them in sequence, skipping itself to avoid recursion.

---

## 🛠️ What It Does

- Locates the `Scripts/` directory relative to the current path.
- Checks if the directory exists.
- Loops through all files in the directory.
- Makes each file executable.
- Skips itself (`star.sh`) to prevent infinite execution.
- Executes all other `.sh` scripts one by one.

---

## 🧑‍💻 How to Use

1. Ensure all your desired `.sh` scripts (like `jenkins.sh`, `git.sh`, etc.) are inside the `Scripts/` folder on your **remote EC2 instance**.

2. SSH into your EC2 instance:

```bash
ssh -i ~/.ssh/your-key.pem ubuntu@<EC2_PUBLIC_IP>
```

3. Navigate to the script folder if needed, then run:

```bash
bash ~/Scripts/star.sh
```

---

## 📂 Directory Example

```
~/Scripts/
├── jenkins.sh
├── git.sh
├── star.sh
```

---

## ✅ Output Example

```
🚀 Starting execution of all scripts inside the 'Scripts' directory...
🔧 Making executable: git.sh
▶️ Running: git.sh
✅ Completed: git.sh
🔧 Making executable: jenkins.sh
▶️ Running: jenkins.sh
✅ Completed: jenkins.sh
⏭️ Skipping self: star.sh
🎉 All scripts in 'Scripts' executed successfully.
```

---

## 📌 Notes

- `set -euo pipefail` ensures the script exits on any error, unbound variable, or failed pipeline.
- This script should only be run on the **remote EC2 instance** after transferring files using `automation_script.sh`.

---

