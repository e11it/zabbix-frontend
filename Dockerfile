FROM debian:jessie
MAINTAINER im@e11it.ru

ENV ZBX_MAIN_VER=3.2
ENV ZBX_VERSION=3.2.7   
ENV DEBIAN_FRONTEND noninteractive

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
    ttf-dejavu-core \
    locales

RUN    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && sed -i 's/^# *\(ru_RU.UTF-8\)/\1/' /etc/locale.gen \
    && sed -i 's/^# *\(C.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && dpkg-reconfigure locales

RUN wget http://repo.zabbix.com/zabbix/${ZBX_MAIN_VER}/debian/pool/main/z/zabbix/zabbix-frontend-php_${ZBX_VERSION}-1+jessie_all.deb -O /tmp/zf.deb \
    && dpkg -i /tmp/zf.deb \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/fpm/

ADD etc/nginx/conf.d/zabbix.conf /etc/nginx/conf.d/zabbix.conf
ADD etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf


VOLUME /etc/nginx/conf.d
VOLUME /var/run/fpm
VOLUME /usr/share/zabbix

CMD ["php5-fpm","-c","/etc/php5/fpm/php.ini","-F","-O"]
