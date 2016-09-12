FROM debian:jessie
MAINTAINER im@e11it.ru

ENV ZBX_VERSION=3.0.4

ADD sources.list /etc/apt/sources.list


RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    apache2 \
    php5 \
    php5-snmp \
    php5-ldap \
    php5-readline \
    php5-pgsql \
    php5-json \
    php5-gd \
    php5-common \
    php5-fpm \
    snmp-mibs-downloader \
    ttf-dejavu-core

RUN wget http://repo.zabbix.com/zabbix/3.0/debian/pool/main/z/zabbix/zabbix-frontend-php_${ZBX_VERSION}-1+jessie_all.deb -O /tmp/zf.deb \
    && dpkg -i /tmp/zf.deb \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/fpm/

ADD etc/nginx/conf.d/zabbix.conf /etc/nginx/conf.d/zabbix.conf
ADD etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf

VOLUME /etc/nginx/conf.d
VOLUME /var/run/fpm
VOLUME /usr/share/zabbix

CMD ["php5-fpm","-c","/etc/php5/fpm/php.ini","-F","-O"]
