cd /var/www/vhosts/themobstate.com/apps/mafia_game || exit 1
docker compose --env-file .env.plesk -f docker-compose.plesk.yml logs -f --tail=80 backend
