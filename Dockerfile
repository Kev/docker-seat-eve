FROM debian:stretch
MAINTAINER kevin@kismith.co.uk

VOLUME /storage
VOLUME /installed

EXPOSE 80

RUN apt-get update && \
    apt-get install -y wget lsb-release curl git supervisor gnupg2 apt-transport-https ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y procps curl mysql-client rsyslog supervisor php7.1-mysql php7.1-fpm php7.1-cli php7.1-common php7.1-mcrypt php7.1-intl php7.1-curl php7.1-gd php7.1-mbstring php7.1-dom php7.1-bz2 nginx redis-server git supervisor unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && hash -r


ADD init.sh /init.sh
ADD run.sh /run.sh
ADD manualinit.sh /manualinit.sh
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD nginx-seat /etc/nginx/sites-available/seat
ADD crontab.txt /crontab.txt
RUN crontab -u www-data /crontab.txt

RUN chmod u+rwx /*.sh

# RUN cd / &&composer create-project eveseat/seat seat --keep-vcs --prefer-source --no-dev
RUN cd / &&composer create-project eveseat/seat seat --no-dev

# RUN curl -fsSL https://git.io/vXb0u -o /usr/local/bin/seat && chmod +x /usr/local/bin/seat

CMD /init.sh && /run.sh
