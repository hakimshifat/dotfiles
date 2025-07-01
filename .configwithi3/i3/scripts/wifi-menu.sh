#!/usr/bin/env bash
# Creado por: Gonka79
# Mail: gonka79@protonmail.com
# Github : Gonka79
# Twitter: Gonka79

# Automatically detect the Wi-Fi interface
interface=$(nmcli -t -f DEVICE,TYPE dev | grep ':wifi$' | cut -d':' -f1 | head -n1)

# Theme for Rofi (ensure this path is correct)
rofi_theme="$HOME/.config/rofi/wifi-menu.rasi"

# Check if a Wi-Fi interface was found
if [ -z "$interface" ]; then
  if [ "$1" != "--select" ]; then # Called by Polybar
    echo "󰤯 No WiFi IF"           # Icon for "No Wi-Fi Interface"
    exit 0
  else # Called for selection
    rofi -e "No Wi-Fi interface found." -theme "$rofi_theme"
    exit 1
  fi
fi

# Function to list available Wi-Fi networks
list_networks() {
  # nmcli -t: terse mode, -f fields: specify fields
  # --rescan auto: tells nmcli to rescan for networks if appropriate
  # awk:
  #   -F: sets colon as delimiter
  #   !seen[$1]++: ensures unique SSIDs (first encountered is kept)
  #   $1!="": ensures SSID is not empty
  #   gsub(/\\:/,":",$1): replaces escaped colons in SSIDs with actual colons (for display)
  #   ($2==""||$2=="--"?"Open":$2): standardizes open networks display to "Open"
  nmcli -t -f SSID,SECURITY dev wifi list ifname "$interface" --rescan auto |
    awk -F: '!seen[$1]++ && $1!=""{gsub(/\\:/,":",$1); print "📶 " $1 " - " ($2==""||$2=="--"?"Open":$2)}'
}

# Function to handle network selection and connection
choose_network() {
  networks=$(list_networks)
  if [ -z "$networks" ]; then
    rofi -e "No Wi-Fi networks found. Try again." -theme "$rofi_theme"
    exit 0
  fi

  chosen_network_line=$(echo -e "$networks" |
    rofi -dmenu -theme "$rofi_theme" -p "Wi-Fi Networks" -mesg "Interface: $interface")

  # Exit if no network is chosen (e.g., user pressed Esc in Rofi)
  if [ -z "$chosen_network_line" ]; then
    exit 0
  fi

  # Extract SSID and Security information from the chosen line
  # This parsing assumes SSIDs don't contain " - " followed by typical security terms.
  # It's a common simplification; very complex SSIDs might require more advanced parsing.
  ssid_part_no_icon=$(echo "$chosen_network_line" | sed 's/📶 //')
  # Attempt to extract SSID by removing known security suffixes from the end
  ssid=$(echo "$ssid_part_no_icon" | sed -E 's/ - (Open|WEP|WPA.*)$//')
  security_info=$(echo "$ssid_part_no_icon" | awk -F ' - ' '{print $NF}') # Get the last field after " - "

  pass="" # Initialize password variable
  # If the network is not "Open", prompt for a password
  if [[ "$security_info" != "Open" ]]; then
    pass_input=$(rofi -dmenu -password -theme "$rofi_theme" -p "Password for: $ssid")
    # Check if the user cancelled the password prompt (Rofi exits with non-zero status)
    if [ $? -ne 0 ]; then
      rofi -e "Connection cancelled for $ssid." -theme "$rofi_theme"
      exit 0
    fi
    pass="$pass_input"
  fi

  # Provide immediate feedback that connection is being attempted
  rofi_msg_pid=""
  rofi -e "Attempting to connect to '$ssid'..." -theme "$rofi_theme" &
  rofi_msg_pid=$!
  # Allow a moment for the message to appear
  sleep 0.2

  # Prepare nmcli connection command parts for safer execution
  connect_cmd_parts=("nmcli" "dev" "wifi" "connect" "$ssid" "ifname" "$interface")
  if [ -n "$pass" ]; then
    connect_cmd_parts+=("password" "$pass")
  elif [[ "$security_info" != "Open" && -z "$pass" ]]; then
    # If secured network and password is empty (user just hit enter), nmcli will likely fail
    # or use a stored connection/agent. This script doesn't prevent empty password submission.
    : # Let nmcli handle it
  fi

  # Execute the connection command and capture all output
  connection_output=$("${connect_cmd_parts[@]}" 2>&1)
  connection_status=$?

  # Kill the "Attempting to connect..." Rofi window if it's still there
  if [ -n "$rofi_msg_pid" ] && ps -p "$rofi_msg_pid" >/dev/null; then
    kill "$rofi_msg_pid"
  fi

  # Display connection result
  if [ $connection_status -eq 0 ]; then
    rofi -e "Successfully connected to '$ssid'." -theme "$rofi_theme"
  else
    # Try to extract a more specific error message from nmcli's output
    error_message=$(echo "$connection_output" | grep -i "Error:" | head -n1 | sed 's/^Error: //')
    if [ -z "$error_message" ]; then
      if echo "$connection_output" | grep -q "Secrets were required"; then
        error_message="Password incorrect or required."
      elif echo "$connection_output" | grep -q "No network with SSID"; then
        error_message="Network '$ssid' not found. It may have gone out of range."
      else
        # Use the last line of output as a generic fallback error
        error_message="Unknown error. $(echo "$connection_output" | tail -n1)"
      fi
    fi
    rofi -e "Connection to '$ssid' failed: $error_message" -theme "$rofi_theme"
  fi
}

# Main script logic: Either show current network for Polybar or run selection menu
if [ "$1" == "--select" ]; then
  choose_network
else
  # Get current active Wi-Fi network for Polybar display
  # nmcli -t: terse, -f ACTIVE,SSID: fields, dev wifi: wifi devices
  # grep '^yes:': filter for active connections (output is "yes:SSID_NAME")
  current_connection_info=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes:')
  if [ -n "$current_connection_info" ]; then
    # Extract SSID (everything after the first colon, to support SSIDs with colons)
    current_ssid=$(echo "$current_connection_info" | cut -d ':' -f2-)
    echo " $current_ssid" # Icon for connected Wi-Fi
  else
    echo "󰤯 No Connection" # Icon for "No Connection"
  fi
fi
