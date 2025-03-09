#!/bin/bash

# もし既に生成済みでなければ自己署名証明書を生成 (二重生成を防ぐ例)
if [ ! -f /etc/ssl/certs/server.crt ] || [ ! -f /etc/ssl/private/server.key ]; then
    echo "Generating self-signed certificate..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=42Tokyo/CN=${DOMAIN_NAME}" \
        -keyout /etc/ssl/private/server.key \
        -out /etc/ssl/certs/server.crt
fi

# nginx 実行
exec "$@"
