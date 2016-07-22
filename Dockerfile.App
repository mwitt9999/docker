FROM ubuntu:14.04

RUN apt-get update

#install server dependencies
RUN apt-get install -y curl apache2 php5 php5-pgsql php5-xdebug php5-dev php-pear vim git yum supervisor wget

#install composer
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

#install mail
RUN pear install Mail

#copy server config files for php, apache, redis, etc...
COPY ./docker/apache/php.ini /etc/php5/apache2/php.ini
COPY ./docker/apache/apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY ./docker/apache/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#expose ports
EXPOSE 80
EXPOSE 443

#run supervisord (runs server commands)
CMD ["/usr/bin/supervisord"]
