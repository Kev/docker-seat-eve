#Unfortunately, there's a necessary manual init step, so wait for the admin to run that
while [ ! -f /installed/yep ]; do
	echo "use 'exec -it containername /bin/bash' to run /manualinit.sh so the container can start up"
	sleep 60
done
#nginx likes to daemonize, so let it
/usr/sbin/nginx
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
