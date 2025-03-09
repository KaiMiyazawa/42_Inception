FROM debian:11

RUN apt-get update && apt-get install -y \
	php7.4-fpm \
	php7.4-mysqli \
	curl \
	iputils-ping \
	sudo \
	tini \
	procps \
	sendmail

RUN mkdir -p /run/php && \
	mkdir -p /var/www/html && \
	chown -R www-data:www-data /run/php && \
	chown -R www-data:www-data /var/www/html

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY script.sh .
RUN chmod +x script.sh

EXPOSE 9000

ENTRYPOINT [ "/usr/bin/tini", "--", "./script.sh" ]
CMD ["php-fpm7.4", "-F"]