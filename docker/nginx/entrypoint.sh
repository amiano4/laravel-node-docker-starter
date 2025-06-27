#!/bin/sh

if [ "$USE_HTTPS" = "true" ]; then
  cp /etc/nginx/templates/https.conf /etc/nginx/conf.d/default.conf
else
  cp /etc/nginx/templates/http.conf /etc/nginx/conf.d/default.conf
fi

exec nginx -g 'daemon off;'
