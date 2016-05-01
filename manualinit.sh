if [ ! -f /installed/yep ]; then
	echo "Not installed yet, installing seat"
	sed -e 's,;daemonize = yes,daemonize = no,' -i /etc/php5/fpm/php-fpm.conf

	sed -e 's,pm = dynamic,pm = ondemand,' -i /etc/php5/fpm/pool.d/www.conf
	sed -e 's,;cgi.fix_pathinfo=1,cgi.fix_pathinfo=0,' -i /etc/php5/fpm/pool.d/www.conf
	echo 'daemonize no' >> /etc/redis/redis.conf

	php5enmod mcrypt


	cd /seat
	for i in logs app framework sde; do
		mkdir -p /seat/storage/$i
		mv /seat/storage/$i /storage/
		ln -s /storage/$i /seat/storage/$i
	done
	chown -R www-data:www-data /storage/*

	# Set a shell so we can su everything
	#chsh -s /bin/bash www-data
	php artisan vendor:publish --force
	php artisan migrate
	php artisan db:seed --class=Seat\\Services\\database\\seeds\\NotificationTypesSeeder
	php artisan db:seed --class=Seat\\Services\\database\\seeds\\ScheduleSeeder
	php artisan eve:update-sde -n
	php artisan seat:admin:reset
	php artisan seat:admin:email

	chown -R www-data:www-data /storage/*
	touch /installed/yep
else
	echo 'Already initialised!'
fi
