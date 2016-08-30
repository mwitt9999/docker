#FROM ubuntu:14.04
FROM php:5.5-apache

RUN apt-get update

#install server dependencies
RUN apt-get install -y sudo curl vim php-pear libpq-dev postgresql-9.4 postgresql-client-9.4

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN sed -i '1 a xdebug.remote_autostart=true' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i '1 a xdebug.remote_mode=req' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i '1 a xdebug.remote_handler=dbgp' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i '1 a xdebug.remote_connect_back=1 ' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i '1 a xdebug.remote_port=9000' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i '1 a xdebug.remote_host=127.0.0.1' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i '1 a xdebug.remote_enable=1' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'short_open_tag=On' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN buildDeps=" \
        libfreetype6-dev \
        libjpeg-dev \
        libldap2-dev \
        libmcrypt-dev \
        libpng12-dev \
        zlib1g-dev \
    "; \
    set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/include/postgresql/ \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install zip \
    && docker-php-ext-install mbstring \
    && apt-get purge -y --auto-remove $buildDeps

RUN echo 'AddHandler php5-script .php .html' >> /etc/apache2/apache2.conf
RUN echo 'AddType text/html .php .html' >> /etc/apache2/apache2.conf
RUN echo 'DirectoryIndex index.php index.html' >> /etc/apache2/apache2.conf

#install composer
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

#install mail
RUN pear install Mail

#copy server config files for php, apache, redis, etc...
COPY ./docker/apache/php.ini /usr/local/etc/php/php.ini
#COPY ./docker/apache/apache-config.conf /etc/apache2/sites-available/000-default.conf
#COPY ./docker/apache/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#expose ports
EXPOSE 80
EXPOSE 443
EXPOSE 8100

#run supervisord (runs server commands)
#CMD ["/usr/bin/supervisord"]
