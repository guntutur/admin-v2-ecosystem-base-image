# docker-ubuntu16-apache2-php7
A docker image based on Ubuntu 16.04 with Apache2 + PHP 7.0

Based on francarmona/docker-ubuntu16-apache2-php7 with additional libraries included

https://github.com/francarmona/docker-ubuntu16-apache2-php7/blob/master/Dockerfile

## Pull the image

Pull the latest stable version from the [Docker Hub Registry](https://hub.docker.com/r/guntutur/admin-v2-ecosystem-base-image/)
```
docker pull guntutur/admin-v2-ecosystem-base-image:latest
```

If you prefer building the image from source, clone the repository and run docker build

```
git clone https://github.com/guntutur/admin-v2-ecosystem-base-image.git
docker build -t guntutur/admin-v2-ecosystem-base-image .
```

## Run

After building the image, run the container.
```
docker run --name admin-v2-base-image -v ~/path/to/code:/var/www -d -p [host-port]:80 guntutur/admin-v2-ecosystem-base-image
```
Browse to [http://localhost:[host-port]](http://localhost:[host-port]) to view your app.

## Use as a base image

Some cases will be necessary to create a new image using this one as the base, for example to overwrite configuration files.

Create a Dockerfile with following content and then build the image.

```Dockerfile
FROM guntutur/admin-v2-ecosystem-base-image

MAINTAINER Gentur Santoso <guntutur@gmail.com>

# Apache site conf
ADD config/apache/apache-virtual-hosts.conf /etc/apache2/sites-enabled/000-default.conf
ADD config/apache/apache2.conf /etc/apache2/apache2.conf
```

## Packages included

 * apache2
 * apt-transport-https
 * composer
 * curl
 * git
 * php7.0
 * php7.0-cli
 * php7.0-gd
 * php7.0-json
 * php7.0-mbstring
 * php7.0-xml
 * php7.0-xsl
 * php7.0-zip
 * php7.0-soap
 * php7.0-pear
 * php7.0-mcrypt
 * php7.0-curl
 * php7.0-phalcon
 * php-dev
 * libapacha2-mod-php
 * lynx-cur
 * nano

## Exposed ports

80

## Exposed volumes

 - webroot: `/var/www`
 
## Out of the box

 * Ubuntu 16.04 LTS
 * Apache2
 * PHP7
 * Composer
 * CPhalcon
 * Git
 
