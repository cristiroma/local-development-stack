FROM php:7.1-fpm
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmariadb-client-lgpl-dev \
		libmcrypt-dev \
		libmemcached-dev \
		libcurl4-gnutls-dev \
		libc-client-dev libkrb5-dev \
		libldap2-dev \
		libxml2-dev \
		zlib1g-dev libicu-dev g++ \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install -j$(nproc) gettext \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install -j$(nproc) imap \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) intl \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-install -j$(nproc) ldap \
	&& docker-php-ext-install -j$(nproc) mysqli \
	&& docker-php-ext-install -j$(nproc) opcache \
	&& docker-php-ext-install -j$(nproc) pdo_mysql \
	&& docker-php-ext-install -j$(nproc) xmlrpc

COPY php.ini /usr/local/etc/php