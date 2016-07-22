FROM    ubuntu:14.04
RUN     apt-get update && apt-get install -y redis-server vim git yum supervisor wget

#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY redis.conf /etc/redis/redis.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#setup redis db dir
RUN mkdir -p /usr/local/var/db/redis/

#setup log directory for supervisor
RUN mkdir -p /var/log/supervisor

#expose redis port
EXPOSE 6379

#run supervisord (runs server commands)
CMD ["/usr/bin/supervisord"]

