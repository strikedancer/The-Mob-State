FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# assets/images/ is excluded from the build context via .dockerignore.
# Recreate every directory declared under flutter.assets in pubspec.yaml,
# otherwise flutter build fails when listed directories are missing.
RUN sed -n '/^  assets:/,/^  [^ ]/p' pubspec.yaml \
  | sed -n 's/^[[:space:]]*-[[:space:]]*//p' \
  | sed -n '/\/$/p' \
  | xargs -r -I{} mkdir -p "{}"

ARG WEB_API_BASE_URL=https://api.themobstate.com
# Cap the Dart heap and skip wasm dry-run. Uncapped flutter build web on an 8G
# VPS (no swap) OOMs MariaDB and freezes SSH/HTTPS.
ENV DART_VM_OPTIONS="--old_gen_heap_size=2048"
RUN flutter build web --release --no-wasm-dry-run --dart-define=WEB_API_BASE_URL=${WEB_API_BASE_URL}

FROM nginx:1.27-alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]