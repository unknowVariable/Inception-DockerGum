#!/bin/sh
set -eu

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ] || [ ! -f /etc/nginx/ssl/inception.key ]; then
  openssl req -x509 -newkey rsa:4096 -nodes \
    -days 365 \
    -subj "/CN=aconstan.42.fr" \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt
fi

exec "$@"
