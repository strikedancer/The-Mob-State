cd /var/www/vhosts/themobstate.com/apps/mafia_game || exit 1
while true; do
  printf '\n===== %s =====\n' "$(date '+%F %T')"
  docker compose --env-file .env.plesk -f docker-compose.plesk.yml exec -T mariadb sh -lc 'MYSQL_PWD="8cd734b7fb6b71925856a13fb44d9ce7ff9c2164afd8ac22" mariadb -uroot mafia_game <<"SQL"
SELECT id, regionKey, status, attackerCrewId, defenderCrewId, winnerCrewId, startedAt, activeAt, lockdownAt, resolveAt, resolvedAt
FROM territory_contests
WHERE regionKey = "nl-noord-brabant"
ORDER BY id DESC
LIMIT 5;
SELECT regionKey, ownerCrewId, controlJson, stability, updatedAt
FROM territory_control
WHERE regionKey = "nl-noord-brabant";
SELECT contestId, actorId, actorCrewId, actionType, pointsDelta, abuseFlagged, createdAt
FROM territory_actions
WHERE regionKey = "nl-noord-brabant"
ORDER BY id DESC
LIMIT 10;
SQL'
  sleep 5
done
