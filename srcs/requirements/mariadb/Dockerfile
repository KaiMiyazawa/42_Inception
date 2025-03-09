FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	mariadb-server \
	iputils-ping \
	tini \
	procps \
	gettext-base

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY init.sql /etc/mysql/init.sql.template
COPY script.sh .

RUN mkdir -p /run/mysqld && chmod +x script.sh

EXPOSE 3306

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD ["./script.sh"]