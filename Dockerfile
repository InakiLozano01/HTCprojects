# Use PHP 8.2 with Apache as the base image
FROM php:8.2-apache

# Install system libraries required by gd, imap, zip, and mysqli extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure the necessary PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install gd imap zip mysqli

# Copy your application code to the container (assuming your code is in the current directory)
COPY . /var/www/html

# Set the working directory to the Apache root
WORKDIR /var/www/html

# Expose port 80 to access Apache
EXPOSE 80

# Set permissions for the Apache root directory
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Use the default Apache configuration
CMD ["apache2-foreground"]