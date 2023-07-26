#!/bin/bash
# Truenas Scale does not detect a new IP, at least not fast enough for my liking.
# This script runs every X minutes as a CRON job.
# Description: DHCP renew, Command: sh /home/admin/dhcp_renew.sh, Run as user: root, Schedule: 0/5 * * * *
# If GW is reachable it exits, if not it request a new IP and makes two beeps.
# If it fails, it makes one beep, waits 10s and retries.
# Make sure to cmhod a+x

#gwip=$(ip r | awk '/^def/{print $3}')


# Function to check if the gateway is reachable
check_gateway() {
  # gwip=$(ip r | awk '/^def/{print $3}')
  # Debug IP (my cellphone)
    gwip=192.168.0.208
    ping -c 1 $gwip > /dev/null 2>&1
    return $?
}

# Function to request a new IP
request_new_ip() {
    dhclient -r > /dev/null 2>&1
    dhclient > /dev/null 2>&1
}

# Main script
while true; do
    if check_gateway; then
        echo "Gateway is reachable. No action needed."
        # echo -en "\a" > /dev/tty5
        # We exit here!
        break
    else
        echo "Gateway is not reachable. Requesting a new IP..."
        request_new_ip
        if check_gateway; then
            echo "New IP requested successfully."
            echo -en "\a" > /dev/tty5
            sleep 3
            echo -en "\a" > /dev/tty5
        else
            echo "Failed to request a new IP. Retrying in 10 seconds..."
            echo -en "\a" > /dev/tty5
            sleep 10
        fi
    fi
done
