#!/bin/bash
# Idempotent: create wiki.themobstate.com and proxy it to Docker :8082.
set -e
DOMAIN="wiki.themobstate.com"
PARENT="themobstate.com"
PORT="${WIKI_PORT:-8082}"

if ! plesk bin subdomain --info wiki -domain "$PARENT" >/dev/null 2>&1; then
  plesk bin subdomain --create wiki -domain "$PARENT" -ssl true || true
fi

CONF_DIR="/var/www/vhosts/system/${DOMAIN}/conf"
if [ ! -d "$CONF_DIR" ]; then
  echo "Plesk conf dir missing for $DOMAIN; create the subdomain in Plesk UI first."
  exit 0
fi

PROXY=$(cat <<EOF
ProxyPreserveHost On
<Location "/.well-known/acme-challenge">
    ProxyPass "!"
</Location>
ProxyPass "/" "http://127.0.0.1:${PORT}/"
ProxyPassReverse "/" "http://127.0.0.1:${PORT}/"
RequestHeader set X-Forwarded-Proto "https"
RequestHeader set X-Forwarded-Port "443"
EOF
)
printf '%s\n' "$PROXY" > "$CONF_DIR/vhost.conf"
printf '%s\n' "$PROXY" > "$CONF_DIR/vhost_ssl.conf"
plesk sbin httpdmng --reconfigure-domain "$DOMAIN" || true
apachectl configtest && systemctl reload apache2 || true
plesk bin extension --exec letsencrypt cli.php -d "$DOMAIN" -m administratie@themobstate.com || true
plesk bin domain -u "$DOMAIN" -ssl true -ssl-redirect true || true
echo "Wiki vhost ready: https://${DOMAIN} -> 127.0.0.1:${PORT}"
