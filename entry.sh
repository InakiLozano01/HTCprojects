#!/bin/bash

chown -R www-data:www-data /var/www/html/
chmod 755 /var/www/html/uploads/
chmod 755 /var/www/html/application/config/
chmod 755 /var/www/html/application/config/config.php
chmod 755 /var/www/html/application/config/app-config-sample.php
chmod 755 /var/www/html/temp/

# Execute the original entrypoint script with all its arguments
exec docker-php-entrypoint "$@"