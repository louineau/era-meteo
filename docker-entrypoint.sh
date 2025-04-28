#!/bin/sh
envsubst '${NGINX_PORT} ${NGINX_SERVER_NAME}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'
