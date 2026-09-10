#!/bin/sh
set -eu

CONTENT="${WIKI_CONTENT:-/content}"
OUT="${WIKI_OUT:-/usr/share/nginx/html}"
SRC="${WIKI_SRC:-/wiki/src}"

if [ ! -f "$CONTENT/countries.json" ]; then
  echo "wiki: missing $CONTENT/countries.json — mount backend/content at /content" >&2
  exit 1
fi

echo "wiki: generating almanac from $CONTENT"
node "$SRC/build.mjs" --content "$CONTENT" --out "$OUT"

node "$SRC/watch.mjs" --content "$CONTENT" --src "$SRC" --out "$OUT" --skip-initial &
WATCH_PID=$!

/docker-entrypoint.sh nginx -g "daemon off;" &
NGINX_PID=$!

term() {
  kill "$WATCH_PID" "$NGINX_PID" 2>/dev/null || true
  wait "$WATCH_PID" "$NGINX_PID" 2>/dev/null || true
}
trap term INT TERM

set +e
wait "$NGINX_PID"
status=$?
term
exit "$status"
