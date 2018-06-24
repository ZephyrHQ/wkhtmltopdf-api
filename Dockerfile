FROM php:7.2-cli-alpine

RUN apk add --no-cache \
  libstdc++ \
  libx11 \
  libxrender \
  libxext \
  libssl1.0 \
  ca-certificates \
  fontconfig \
  freetype \
  ttf-dejavu \
  ttf-droid \
  ttf-freefont \
  ttf-liberation \
  ttf-ubuntu-font-family \
  icu-dev \
  && docker-php-ext-install intl opcache \
  && apk --no-cache add --upgrade icu-libs \
  && apk del icu-dev

WORKDIR /app

COPY docker/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

COPY app /app
RUN wget https://github.com/ZephyrHQ/wkhtmltopdf/blob/master/wkhtmltopdf?raw=true -O /bin/wkhtmltopdf \
    && chmod +x /bin/wkhtmltopdf \
    && cd /app \
    && cp .env.dist .env \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php \
    && cd /app \
    && COMPOSER_ALLOW_SUPERUSER=1 composer install \
    && COMPOSER_ALLOW_SUPERUSER=1 composer clear-cache \
    && rm -rf vendor/symfony/*/[tT]ests* \
    && rm /usr/local/bin/composer \
    && bin/console cache:warmup

EXPOSE 80

ENV APP_ENV=dev
ENV APP_SECRET=6f6602bcbac5846fcf2a3f245148ef3e
ENV WKHTMLTOPDF_PATH=/bin/wkhtmltopdf
ENV WKHTMLTOIMAGE_PATH=/bin/wkhtmltoimage

ENTRYPOINT ["entrypoint"]

CMD ["/app/bin/console", "server:run", "0.0.0.0:80", "--env=dev"]
