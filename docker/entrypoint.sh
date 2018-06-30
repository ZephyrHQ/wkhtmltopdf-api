#!/bin/sh
set -e

# Installations
if [ ! -f /lock-install ]; then
    echo "installation des composants initiaux"

    # Installation outils console
    if [ "${CONTAINER_ENV}" = "dev" ]; then
        EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

        if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
        then
            >&2 echo 'ERROR: Invalid installer signature'
            rm composer-setup.php
            exit 1
        fi

        php composer-setup.php --install-dir=/usr/local/bin --filename=composer
        rm composer-setup.php
        echo Installation Outils
        apk add --no-cache vim curl wget bash bash-completion
        wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -O /usr/local/bin/php-cs-fixer
        chmod +x /usr/local/bin/php-cs-fixer
        composer install
    fi
    echo Fin des installations
    touch /lock-install

fi

env

echo exec "$@"
exec "$@"
