FROM php:5.6-apache
MAINTAINER Ian Blenke <ian@blenke.com>

env VERSION 1.13.2

RUN curl https://simplesamlphp.org/res/downloads/simplesamlphp-$VERSION.tar.gz | tar xvzf - --strip-components 1 -C /var/www/html

WORKDIR /var/www/html

RUN cp -r config-templates/* config/
RUN cp -r metadata-templates/* metadata/

VOLUME /var/www/html/config
VOLUME /var/www/html/metadata

# Install the gmp and mcrypt extensions
RUN apt-get update -y
RUN apt-get install -y libgmp-dev re2c libmhash-dev libldap2-dev libmcrypt-dev file
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap* /usr/lib
RUN docker-php-ext-configure gmp 
RUN docker-php-ext-install gmp
RUN docker-php-ext-configure mcrypt
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-configure ldap
RUN docker-php-ext-install ldap

RUN echo extension=gmp.so > $PHP_INI_DIR/conf.d/gmp.ini
RUN echo extension=mcrypt.so > $PHP_INI_DIR/conf.d/mcrypt.ini
RUN echo extension=ldap.so > $PHP_INI_DIR/conf.d/ldap.ini


RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar install

