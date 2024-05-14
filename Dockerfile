# Use PHP 8.2 with Apache as the base image
FROM php:8.2-apache

# Expose port 80 to access Apache
EXPOSE 80

# Install necessary system libraries and PHP extensions
RUN apt-get update -y && \
    apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
    mc \
    apt-utils \
    tree \
    htop \
    zip && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli gd zip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install gd imap zip mysqli

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy your application code to the container
COPY ./ /var/www/html/

WORKDIR /var/www/html

# Copy the custom entrypoint script to the container
COPY entry.sh /usr/local/bin/entry.sh

# Make the custom entrypoint script executable
RUN chmod +x /usr/local/bin/entry.sh

# Set ServerName globally to suppress the warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ENTRYPOINT ["/usr/local/bin/entry.sh"]

# Use the default Apache configuration
CMD ["apache2-foreground"]
