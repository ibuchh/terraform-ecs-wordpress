#!/bin/bash

set -e

EC2_PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
WP_INSTALL_URL="http://$EC2_PUBLIC_IP/wp-admin/install.php?step=2"

# Wait random time between 1s and 15s so the container with the lowest wait installs Wordpress, not all at once.
sleep $(shuf -i 1-15 -n 1)

if ! curl -sf $WP_INSTALL_URL | grep "Already Installed"; then

   curl -s -X POST \
        -F "weblog_title=$WORDPRESS_TITLE" \
        -F "user_name=$WORDPRESS_USER" \
        -F "admin_password=$WORDPRESS_PASSWORD" \
        -F "admin_password2=$WORDPRESS_PASSWORD" \
        -F "admin_email=$WORDPRESS_MAIL" \
        -F "blog_public=0" \
        $WP_INSTALL_URL
fi
