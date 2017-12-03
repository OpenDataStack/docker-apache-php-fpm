FROM ubuntu:16.04
MAINTAINER Willie Seabrook<willie@angrycactus.io>

# No tty
ENV DEBIAN_FRONTEND noninteractive

# Apache 2.4 + PHP-7.0-FPM
RUN apt-get update \
    # Tools
    && apt-get -y --no-install-recommends install \
        nano \
    # Supervisor
    && apt-get -y --no-install-recommends install \
        supervisor \
    # Install Apache + PHP
    && apt-get -y --no-install-recommends install \
        apache2 \
        php-fpm php-xml php-mbstring php-bcmath \
    # Configure Apache + PHP
    && a2enconf php7.0-fpm \
    && a2enmod proxy proxy_fcgi \
    # Clean
    && rm -rf /var/lib/apt/lists/*

# Supervisor
RUN mkdir -p /run/php/
COPY config/supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY config/supervisord/conf.d/ /etc/supervisor/conf.d/

# Apache Configuration
COPY ./config/apache/default.conf /etc/apache2/sites-available/default.conf

# PHP Configuration
COPY config/php/fpm/php.ini /etc/php/7.0/fpm/php.ini
COPY config/php/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf

# Startup script to change uid/gid (if environment variable passed) and start supervisord in foreground
COPY ./scripts/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]