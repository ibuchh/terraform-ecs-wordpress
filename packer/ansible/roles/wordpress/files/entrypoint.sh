#!/bin/bash

set -e

cd /usr/share/nginx/html/wordpress

if ! [ -e wp-config.php ] && [ -e wp-config-sample.php ]; then

  sed -ie "s/database_name_here/$WORDPRESS_DB_NAME/g" wp-config-sample.php
  sed -ie "s/username_here/$WORDPRESS_DB_USER/g" wp-config-sample.php
  sed -ie "s/password_here/$WORDPRESS_DB_PASSWORD/g" wp-config-sample.php
  sed -ie "s/localhost/$WORDPRESS_DB_HOST/g" wp-config-sample.php

fi

KEYS=(
  AUTH_KEY
  SECURE_AUTH_KEY
  LOGGED_IN_KEY
  NONCE_KEY
  AUTH_SALT
  SECURE_AUTH_SALT
  LOGGED_IN_SALT
  NONCE_SALT
)

for KEY in "${KEYS[@]}"; do
  RAND=$(openssl rand -base64 48)
  sed -ie "/\<$KEY\>/s#put\ your\ unique\ phrase\ here#$RAND#g" wp-config-sample.php
done

mv wp-config-sample.php wp-config.php

cd /

exec "$@"