#!/bin/bash

LOG_FILE="/var/log/secure"

# info about the user, key, address, and time
extract_login_info() {
  grep "Accepted publickey" $LOG_FILE | while read -r line ; do
    # Extracting the username, IP, and datetime
    user=$(echo $line | grep -oP 'for \K[^ ]+')
    ip=$(echo $line | grep -oP 'from \K[^ ]+')
    datetime=$(echo $line | grep -oP '^\w+ +\d+ \d+:\d+:\d+')
    key=$(echo $line | grep -oP 'key:\K.+')

    # Searching for the public key that was used for authentication
    key_path="/home/$user/.ssh/authorized_keys"
    if [ "$user" == "root" ]; then
      key_path="/root/.ssh/authorized_keys"
    fi

    if [ -f "$key_path" ]; then
      # Checking fingerprint matches any in authorized_keys
      while IFS= read -r line_key; do
        saved_key=$(echo $line_key | awk '{print $2}')
        if [[ "$saved_key" == *"$key"* ]]; then
          echo "User: $user, IP: $ip, Time: $datetime, Key: $saved_key"
        fi
      done < "$key_path"
    else
      echo "Authorized keys for user $user not found or user does not exist."
    fi
  done
}

extract_login_info
