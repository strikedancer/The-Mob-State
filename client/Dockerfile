FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

ARG WEB_API_BASE_URL=https://api.themobstate.com
RUN flutter build web --release --dart-define=WEB_API_BASE_URL=${WEB_API_BASE_URL}

# Strip bundled images — served from external runtime mount (runtime/client-images).
# AssetManifest.json remains intact so Flutter web still makes HTTP requests;
# nginx extern-first routes serve those requests from the mounted volume.
RUN rm -rf /app/build/web/assets/assets/images

FROM nginx:1.27-alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]