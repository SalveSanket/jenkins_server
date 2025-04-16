#!/bin/bash

set -euo pipefail

echo "🚀 Starting execution of all scripts inside the 'Scripts' directory..."

# Get the absolute path to the 'Scripts' directory relative to current working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXEC_DIR="$SCRIPT_DIR/../Scripts"

# Check if the directory exists
if [[ ! -d "$EXEC_DIR" ]]; then
  echo "❌ Error: 'Scripts' directory not found at expected location: $EXEC_DIR"
  exit 1
fi

# Find and loop through all files in the Scripts directory
for script in "$EXEC_DIR"/*; do
  if [[ -f "$script" ]]; then
    # Skip this script itself
    if [[ "$script" == "$SCRIPT_DIR/star.sh" ]]; then
      echo "⏭️ Skipping self: $script"
      continue
    fi

    echo "🔧 Making executable: $script"
    chmod +x "$script"

    echo "▶️ Running: $script"
    "$script"
    echo "✅ Completed: $script"
  else
    echo "⚠️ Skipping non-file item: $script"
  fi
done

echo "🎉 All scripts in 'Scripts' executed successfully."