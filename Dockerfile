FROM dunglas/frankenphp
ARG S6_OVERLAY_VERSION=3.2.0.2

# PHP
RUN install-php-extensions pdo_pgsql intl zip opcache

# composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# S6 Overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ENTRYPOINT ["/init"]

# Laravel
COPY services/horizon.sh /etc/services.d/horizon/run
COPY services/cron.sh /etc/services.d/cron/run
COPY services/crontab /etc/cron.d/www-data
COPY services/migrations.sh /etc/cont-init.d/migrations

WORKDIR /app
