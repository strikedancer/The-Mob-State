# syntax=docker/dockerfile:1
FROM node:22-alpine AS builder
WORKDIR /wiki
COPY src ./src
COPY nginx.conf ./nginx.conf
COPY content ./content
RUN node src/build.mjs --content /wiki/content --out /out

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /out /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
