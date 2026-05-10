FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
COPY assets /usr/share/nginx/html/assets
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=5s --timeout=5s --retries=5 \
  CMD wget -qO- http://localhost || exit 1

EXPOSE 80
