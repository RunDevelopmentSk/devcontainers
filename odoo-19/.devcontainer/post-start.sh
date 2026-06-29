#!/bin/bash
# this script is used as "postStartCommand" in devcontainer.json

# create symbolic link to odoo sources to have it accessible inside project folder
rm -rf /mnt/odoo-sources
ln -s /usr/lib/python3/dist-packages/odoo /mnt/odoo-sources

# create symbolic link to odoo log to have it accessible inside project folder
rm -rf /mnt/tmp/log
ln -s /var/log/odoo /mnt/tmp/log

# clear log file
truncate -s 0 /var/log/odoo/odoo.log 2>/dev/null || true
