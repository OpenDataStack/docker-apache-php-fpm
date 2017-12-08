FROM ubuntu:16.04
MAINTAINER Willie Seabrook<willie@angrycactus.io>

# No tty
ENV DEBIAN_FRONTEND noninteractive

# Apache 2.4 + PHP-7.0-FPM
RUN apt-get update \
    # Tools
    && apt-get -y --no-install-recommends install \
        curl \
        ca-certificates \
        nano \
        zip \
        git \
    # Supervisor
    && apt-get -y --no-install-recommends install \
        supervisor \
    # MySQL Client
    && apt-get -y --no-install-recommends install \
        mariadb-client-10.0 \
    # Install Apache + PHP
    && apt-get -y --no-install-recommends install \
        apache2 \
        php-fpm php7.0-mysql php7.0-xml php7.0-gd php7.0-mbstring php7.0-bcmath php-memcache \
        php7.0-curl \
        php-xdebug \
    # Configure Apache + PHP
    && a2enconf php7.0-fpm \
    && a2enmod proxy \
    && a2enmod proxy_fcgi \
    && a2enmod rewrite \
    # Clean
    && rm -rf /var/lib/apt/lists/*

# Drupal Tools
RUN curl -sf -o /usr/bin/composer -L https://getcomposer.org/download/1.5.5/composer.phar \
    && chmod +x /usr/bin/composer \
    && curl -sf -o /usr/bin/drush -L https://github.com/drush-ops/drush/releases/download/8.1.15/drush.phar \
    && chmod +x /usr/bin/drush

# Supervisor
RUN mkdir -p /run/php/
COPY config/supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY config/supervisord/conf.d/ /etc/supervisor/conf.d/

# Apache Configuration
COPY ./config/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# PHP Configuration
COPY config/php/fpm/php.ini /etc/php/7.0/fpm/php.ini
COPY config/php/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY config/php/fpm/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini

# Startup script to change uid/gid (if environment variable passed) and start supervisord in foreground
COPY ./scripts/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]