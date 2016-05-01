FROM debian:8
MAINTAINER kevin@kismith.co.uk

VOLUME /storage
VOLUME /installed

EXPOSE 80

RUN apt-get update && apt-get install -y procps curl mysql-client rsyslog supervisor php5-mysql php5-fpm php5-cli php5-common php5-mcrypt php5-intl php5-curl php5-gd nginx redis-server git supervisor

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && hash -r


ADD init.sh /init.sh
ADD run.sh /run.sh
ADD manualinit.sh /manualinit.sh
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD nginx-seat /etc/nginx/sites-available/seat
ADD crontab.txt /crontab.txt
RUN crontab -u www-data /crontab.txt

RUN chmod u+rwx /*.sh 

RUN cd / &&composer create-project eveseat/seat seat --keep-vcs --prefer-source --no-dev  

CMD /init.sh && /run.sh 

