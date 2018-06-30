FROM alpine:edge

# ensure www-data user exists
RUN apk add --update --no-cache php7 \
    php7-fpm \
    php7-dom \
    php7-opcache \
    php7-phar \
    php7-openssl \
    php7-curl \
    php7-ctype \
    php7-xml \
    php7-iconv \
    php7-json \
    php7-mbstring \
    lighttpd \
    php7-cgi \
    fcgi \
    && echo "Fin des installation php"

RUN apk add --update --no-cache \
  libstdc++ \
  libx11 \
  libxrender \
  libxext \
  libssl1.0 \
  ca-certificates \
  fontconfig \
  freetype \
  ttf-dejavu \
  #ttf-droid \
  #ttf-freefont \
  #ttf-liberation \
  #ttf-ubuntu-font-family \
  && echo "Fin des installations des bibliothèques pour wkhtml"

WORKDIR /app

RUN wget https://github.com/ZephyrHQ/wkhtmltopdf/blob/master/wkhtmltopdf?raw=true -O /bin/wkhtmltopdf \
    && chmod +x /bin/wkhtmltopdf

COPY app /app
RUN cd /app \
    && cp .env.dist .env \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php \
    && cd /app \
    && COMPOSER_ALLOW_SUPERUSER=1 composer install \
    && COMPOSER_ALLOW_SUPERUSER=1 composer clear-cache \
    && rm -rf vendor/symfony/*/[tT]ests* \
    && rm /usr/local/bin/composer \
    && bin/console cache:warmup \
    && echo "Fin des installations de l'application"

EXPOSE 80

COPY docker/lighttpd.conf /etc/lighttpd/lighttpd.conf
RUN mkdir /run/lighttpd/ \
    && chown lighttpd:lighttpd /run/lighttpd/

COPY docker/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENV APP_ENV=prod
ENV APP_SECRET=6f6602bcbac5846fcf2a3f245148ef3e
ENV WKHTMLTOPDF_PATH=/bin/wkhtmltopdf
ENV WKHTMLTOIMAGE_PATH=/bin/wkhtmltoimage

ENTRYPOINT ["entrypoint"]

CMD ["/app/bin/console", "server:run", "0.0.0.0:80", "--env=dev"]
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
