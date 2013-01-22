## Install additional package dependencies
#
# Update the system
execute "apt-get-update" do
  user "root"
  command "apt-get update"
end

# include_recipe "ohai"

# Create some users for this server
#
include_recipe "user::data_bag"

## Hardening recipes
#
# Install ufw, apply allow/deny rules, these are specified as part of the role (overriden attributes)
include_recipe "ufw"
# Lockdown ssh, deny root login
include_recipe "openssh"
# Additional packages to be installed
package "ntp"
# for NTP
# Create the file /etc/cron.d/ntp with the following line: 15 * * * * root /usr/sbin/ntpdate server
# ...etc

# Cron job for updates?

# 10. Disable IPv6
# - Disable it when not required.
# Edit the following line from /etc/modprobe.d/aliases:
# · Find the line: alias net-pf-10 ipv6
# · Edit this to: alias net-pf-10 off ipv6 · Save the file and reboot

# 11. Disable Compile ·
# Add compiler group: /usr/sbin/groupadd compiler
# · Move to correct directory: cd /usr/bin
# · Make most common compilers part of the compiler group
# chgrp compiler *cc* chgrp compiler *++* chgrp compiler ld chgrp compiler as
# · Set access on mysqlaccess chgrp root mysqlaccess
# · Set permissions
# chmod 750 *cc*
# chmod 750 *++* chmod 750 ld
# chmod 750 as
# chmod 755 mysqlaccess
# · To add users to the group, modify /etc/group and change compiler ￼ :123: to compiler ￼ :123:username1,username2 ('123' will be different on your installation)

# 13. Securing History
# chattr +a .bash_history (append)
# chattr +I .bash_history
# Get your users know that their history is being locked and they will have to agree before they use your services.
# 14. Using Welcome Message
# Edit /etc/motd and put the following banner to be displayed:
# WARNING !!!
# This computer system including all related equipment, network devices (specifically including Internet access), are provided only for authorized use.
# Unauthorized use may subject you to criminal prosecution. By accessing this system, you have agreed to the term and condition of use and your actions will be monitored and recorded. □

# chmod 700 /bin/ping
# chmod 700 /usr/bin/who
# chmod 700 /usr/bin/w
# chmod 700 /usr/bin/locate
# chmod 700 /usr/bin/whereis
# chmod 700 /sbin/ifconfig
# chmod 700 /bin/nano
# chmod 700 /usr/bin/vi
# chmod 700 /usr/bin/which
# chmod 700 /usr/bin/gcc
# chmod 700 /usr/bin/make
# chmod 700 /usr/bin/apt-get
# chmod 700 /usr/bin/aptitude
