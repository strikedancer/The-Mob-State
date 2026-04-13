FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# assets/images/ is excluded from the build context via .dockerignore.
# Create the stub directory so pubspec.yaml asset declarations don't fail the build.
# Flutter web's Image.asset() still generates HTTP requests at runtime;
# nginx serves those from the external runtime mount (/mnt/external-images).
RUN mkdir -p assets/images

ARG WEB_API_BASE_URL=https://api.themobstate.com
RUN flutter build web --release --dart-define=WEB_API_BASE_URL=${WEB_API_BASE_URL}

FROM nginx:1.27-alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]