FROM debian:stretch AS build
MAINTAINER Gentur Santoso <guntutur@gmail.com>
LABEL author="Gentur Santoso <guntutur@gmail.com>" \
      maintainer="ID Supply Engineering Team"

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
    apt-get -qq -y install git openssh-client libbz2-dev libxml2-dev libxslt-dev libmcrypt-dev libzip-dev > /dev/null && \
    if [ $ENV = "dev" ] ; then mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" ; else mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" ; fi && \
    echo "error_log = /dev/stderr" > /usr/local/etc/php/conf.d/additional.ini
COPY --from=build /build/cphalcon/build/php7/64bits/modules/phalcon.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/phalcon.so

# Install extensions which already loaded on production instance
RUN docker-php-ext-install  bz2 \
                            calendar \
                            exif \
                            gettext \
                            pdo_mysql \
                            shmop \
                            mcrypt \
                            sysvmsg \
                            sysvsem \
                            sysvshm \
                            wddx \
                            xsl \
                            zip && \
    docker-php-ext-enable phalcon

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# set default document root
ENV APACHE_DOCUMENT_ROOT /var/www/rumah123
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# setup apache2
RUN a2enmod rewrite headers > /dev/null && \
    service apache2 restart
