rm /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/seat /etc/nginx/sites-enabled/

if [ ! -f /seat/.env.clean ]; then
	mv /seat/.env /seat/.env.clean
fi

cat /seat/.env.clean | grep -v DB_HOST | grep -v DB_DATABASE | grep -v DB_USERNAME | grep -v DB_PASSWORD | grep -v CACHE_DRIVER | grep -v SESSION_DRIVER | grep -v QUEUE_DRIVER > /seat/.env

echo "DB_HOST=$MYSQL_PORT_3306_TCP_ADDR" >> /seat/.env
echo "DB_DATABASE=${MYSQL_DATABASE}" >> /seat/.env
echo "DB_USERNAME=${MYSQL_USER}" >> /seat/.env
echo "DB_PASSWORD=${MYSQL_PASSWORD}" >> /seat/.env
echo "CACHE_DRIVER=redis" >> /seat/.env
echo "SESSION_DRIVER=file" >> /seat/.env
echo "QUEUE_DRIVER=redis" >> /seat/.env

