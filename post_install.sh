#!/bin/sh

# This script is run inside the jail after it is created and any packages installed. 
# Enable services in /etc/rc.conf that need to start with the jail and apply any 
# configuration customizations with this this script.

# Enable services

sysrc -f /etc/rc.conf nginx_enable="YES"
sysrc -f /etc/rc.conf mysql_enable="YES"
sysrc -f /etc/rc.conf php_fpm_enable="YES"

# Hur får jag det här att köra i freenas servern
# zfs set primarycache=metadata jailhouse/apps/nextcloud/db

USER="dbadmin"
PASS = "Ra3map1"
DB = "dbname"

# Configure mysql
mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('${PASS}') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
CREATE USER '${USER}'@'localhost' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${DB}.* TO '${USER}'@'localhost';
FLUSH PRIVILEGES;
EOF



# Creating phpinfo.php
echo "<?php phpinfo(); ?>" | tee /usr/local/www/nginx/phpinfo.php

# plugin_schema = 2 
echo "Ett test!" >> /root/PLUGIN_INFO