# truenas_dhcp_renew
Script to renew IP

Truenas Scale does not detect a new IP, at least not fast enough for my liking.
This script runs every X minutes as a CRON job:
Description: DHCP renew
Command: sh /home/admin/dhcp_renew.sh
Run as user: root
Schedule: 0-59/5 * * * *

If GW is reachable it exits, if not it request a new IP and makes two beeps.
If it fails, it makes one beep, waits 10s and retries.

Beeps are made with echo -en "\a" > /dev/tty5

Save file to /home/admin/dhcp_renew.sh
Make sure to chmod a+x dhcp_renew.sh
Tested on Qnap TS-453be.
