FROM php:8.4-fpm

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libicu-dev \
  && docker-php-ext-install pdo_mysql zip intl \
  && rm -rf /var/lib/apt/lists/*

# Composer 2.9 라인 고정(패치 업데이트만 따라감)
COPY --from=composer:2.9 /usr/bin/composer /usr/bin/composer

# 리눅스 환경에서 권한 이슈 줄이기 (호스트 UID/GID 1000 기준)
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
