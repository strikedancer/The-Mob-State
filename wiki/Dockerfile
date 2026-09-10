# syntax=docker/dockerfile:1
FROM nginx:1.27-alpine
RUN apk add --no-cache nodejs
WORKDIR /wiki
COPY src ./src
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh /wiki-entrypoint.sh
RUN chmod +x /wiki-entrypoint.sh \
  && mkdir -p /content /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT ["/wiki-entrypoint.sh"]
