FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# assets/images/ is excluded from the build context via .dockerignore.
# Recreate every directory declared under flutter.assets in pubspec.yaml,
# otherwise flutter build fails when listed directories are missing.
RUN awk '
	/^  assets:/{in_assets=1; next}
	in_assets && /^  [^ ]/{in_assets=0}
	in_assets && /^[[:space:]]*-[[:space:]]*/ {
		path=$0
		sub(/^[[:space:]]*-[[:space:]]*/, "", path)
		gsub(/[[:space:]]+$/, "", path)
		if (path ~ /\/$/) print path
	}
' pubspec.yaml | xargs -r -I{} mkdir -p "{}"

ARG WEB_API_BASE_URL=https://api.themobstate.com
RUN flutter build web --release --dart-define=WEB_API_BASE_URL=${WEB_API_BASE_URL}

FROM nginx:1.27-alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]