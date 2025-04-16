#!/bin/bash

# === CONFIGURATION ===
KEY_PATH="~/.ssh/id_rsa"    # Your private key path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXECUTABLE_DIR="$SCRIPT_DIR/executable"
LOCAL_DIR="$EXECUTABLE_DIR"

# === STEP 1: Extract IP from Terraform output ===
echo "🌐 Fetching EC2 instance details from Terraform..."
EC2_IP=$(terraform output -raw public_ip)

if [[ -z "$EC2_IP" ]]; then
  echo "❌ ERROR: Could not retrieve EC2 IP from Terraform output."
  exit 1
fi

# === STEP 2: Detect AMI and set EC2 user ===
echo "🔍 Detecting AMI and selecting default EC2 user..."
for USERNAME in ubuntu ec2-user admin centos; do
  OS_INFO=$(ssh -o BatchMode=yes -o ConnectTimeout=5 -i "$KEY_PATH" "$USERNAME@$EC2_IP" "cat /etc/os-release" 2>/dev/null)
  if [[ "$OS_INFO" == *"ubuntu"* ]]; then
    EC2_USER="ubuntu"
    echo "✅ Detected Ubuntu"
    break
  elif [[ "$OS_INFO" == *"amzn"* ]]; then
    EC2_USER="ec2-user"
    echo "✅ Detected Amazon Linux"
    break
  elif [[ "$OS_INFO" == *"debian"* ]]; then
    EC2_USER="admin"
    echo "✅ Detected Debian"
    break
  elif [[ "$OS_INFO" == *"centos"* ]]; then
    EC2_USER="centos"
    echo "✅ Detected CentOS"
    break
  fi
done

if [[ -z "$EC2_USER" ]]; then
  echo "❌ ERROR: Could not determine EC2 username from AMI"
  exit 1
fi

REMOTE_DIR="/home/$EC2_USER/Scripts"

echo "✅ EC2 User: $EC2_USER"
echo "✅ EC2 Public IP: $EC2_IP"

# === STEP 3: Wait for instance to be accessible ===
echo "⏳ Waiting for EC2 to be ready for SSH..."
sleep 20

# === STEP 4: Create remote directory ===
echo "📁 Creating '$REMOTE_DIR' on EC2 instance..."
ssh -o StrictHostKeyChecking=no -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "mkdir -p $REMOTE_DIR && chmod 755 $REMOTE_DIR"

# === STEP 5: Show local files
echo -e "\n📂 Local files to copy:"
ls -1 "$LOCAL_DIR"

# === STEP 6: Fetch remote file list
echo -e "\n📁 Fetching existing files on EC2..."
REMOTE_FILES=$(ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "ls -1 $REMOTE_DIR 2>/dev/null")
echo "$REMOTE_FILES"

# === STEP 6.1: Check if remote directory is empty
echo -e "\n📦 Checking if $REMOTE_DIR is empty..."
REMOTE_FILE_COUNT=$(ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "ls -1q $REMOTE_DIR | wc -l")
if [ "$REMOTE_FILE_COUNT" -eq 0 ]; then
  echo "⚠️  Remote directory is empty."
  read -p "Do you want to copy the listed files now? (y/n): " COPY_CONFIRM
  if [[ "$COPY_CONFIRM" == "y" ]]; then
    echo "🚚 Copying files..."
    scp -i "$KEY_PATH" -r "$LOCAL_DIR"/* "$EC2_USER@$EC2_IP:$REMOTE_DIR/"
    echo "✅ All files copied to EC2 at: $REMOTE_DIR"
    exit 0
  else
    echo "⏭️ Skipping copy due to user input."
  fi
fi

# === STEP 7: Interactive copy options
echo -e "\n💬 What would you like to do?"
select ACTION in \
  "Replace all files on remote" \
  "Update a specific file" \
  "Remove a file from remote" \
  "Skip all actions"; do

  case $ACTION in
    "Replace all files on remote")
      echo "🚚 Replacing all files..."
      scp -i "$KEY_PATH" -r "$LOCAL_DIR"/* "$EC2_USER@$EC2_IP:$REMOTE_DIR/"
      echo "✅ All files copied to EC2 at: $REMOTE_DIR"
      break
      ;;
    "Update a specific file")
      echo -n "📄 Enter the name of the file to update: "
      read FILE
      if [ -f "$LOCAL_DIR/$FILE" ]; then
        scp -i "$KEY_PATH" "$LOCAL_DIR/$FILE" "$EC2_USER@$EC2_IP:$REMOTE_DIR/"
        echo "✅ File updated: $FILE"
      else
        echo "❌ File not found locally: $FILE"
      fi
      break
      ;;
    "Remove a file from remote")
      echo -n "🗑️ Enter the name of the file to remove from EC2: "
      read FILE
      ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "rm -f $REMOTE_DIR/$FILE"
      echo "✅ File removed from EC2: $FILE"
      break
      ;;
    "Skip all actions")
      echo "⏩ Skipping all file copy operations."
      break
      ;;
    *)
      echo "❌ Invalid choice. Exiting."
      exit 1
      ;;
  esac
done

echo -e "\n🎉 Script complete. All requested actions handled."