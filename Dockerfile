FROM debian:stretch AS build
MAINTAINER Gentur Santoso <guntutur@gmail.com>
LABEL author="Gentur Santoso <guntutur@gmail.com>" \
      maintainer="ID Supply Team Engineer"

WORKDIR /build

RUN apt-get -qq update && \
    apt-get -qq -y install git gcc make php-dev libpcre3-dev > /dev/null && \
    git clone https://github.com/phalcon/cphalcon.git -b v3.0.4 --depth 1 && \
    cd cphalcon/build && \
    ./install

FROM php:7.0-apache

ARG ENV=prod
ENV ENV=${ENV}

RUN apt-get -qq update && \
    apt-get -qq -y install git openssh-client libbz2-dev libxml2-dev libxslt-dev libmcrypt-dev > /dev/null && \
    if [ $ENV = "dev" ] ; then mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" ; else mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" ; fi && \
    echo "error_log = /dev/stdout" > /usr/local/etc/php/conf.d/additional.ini
COPY --from=build /build/cphalcon/build/php7/64bits/modules/phalcon.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/phalcon.so

# Install extensions which already loaded on production instance
RUN docker-php-ext-configure bz2 && docker-php-ext-install bz2 && \
    docker-php-ext-configure calendar && docker-php-ext-install calendar && \
    docker-php-ext-configure exif && docker-php-ext-install exif && \
    docker-php-ext-configure gettext && docker-php-ext-install gettext && \
    docker-php-ext-configure pdo_mysql && docker-php-ext-install pdo_mysql && \
    docker-php-ext-configure pdo_mysql && docker-php-ext-install pdo_mysql && \
    docker-php-ext-configure shmop && docker-php-ext-install shmop && \
    docker-php-ext-configure mcrypt && docker-php-ext-install mcrypt && \
    docker-php-ext-configure sysvmsg && docker-php-ext-install sysvmsg && \
    docker-php-ext-configure sysvsem && docker-php-ext-install sysvsem && \
    docker-php-ext-configure sysvshm && docker-php-ext-install sysvshm && \
    docker-php-ext-configure wddx && docker-php-ext-install wddx && \
    docker-php-ext-configure xsl && docker-php-ext-install xsl && \
    docker-php-ext-enable phalcon

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# setup apache2
RUN a2enmod rewrite > /dev/null && \
    service apache2 restart
