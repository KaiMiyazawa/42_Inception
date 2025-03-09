FROM debian:11

RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	curl \
	iputils-ping \
	tini \
	procps

COPY default /etc/nginx/sites-available/default
COPY script.sh .
RUN chmod +x script.sh

EXPOSE 443

ENTRYPOINT [ "/usr/bin/tini", "--", "./script.sh" ]
CMD ["nginx", "-g", "daemon off;"]