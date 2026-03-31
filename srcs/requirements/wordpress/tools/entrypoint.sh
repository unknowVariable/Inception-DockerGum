#!/bin/sh
set -eu

: "${DOMAIN_NAME:?DOMAIN_NAME manquant}"
: "${MYSQL_DATABASE:?MYSQL_DATABASE manquant}"
: "${MYSQL_USER:?MYSQL_USER manquant}"
: "${WP_TITLE:?WP_TITLE manquant}"
: "${WP_ADMIN_USER:?WP_ADMIN_USER manquant}"
: "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL manquant}"
: "${WP_USER:?WP_USER manquant}"
: "${WP_USER_EMAIL:?WP_USER_EMAIL manquant}"

if echo "$WP_ADMIN_USER" | grep -qiE 'admin|administrator'; then
  echo "[wordpress] ERROR: WP_ADMIN_USER invalide"
  exit 1
fi

DB_PASS="$(cat /run/secrets/db_password)"
ADMIN_PASS="$(cat /run/secrets/wp_admin_password)"
USER_PASS="$(cat /run/secrets/wp_user_password)"

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html || true

i=0
while ! mariadb -h mariadb -u"${MYSQL_USER}" -p"${DB_PASS}" -e "SELECT 1;" >/dev/null 2>&1; do
  i=$((i+1))
  if [ "$i" -ge 60 ]; then
    echo "[wordpress] ERROR: DB timeout"
    exit 1
  fi
  sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
  echo "[wordpress] Installing WordPress..."
  cd /var/www/html

  wp core download --allow-root

  wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="mariadb:3306" \
    --allow-root

  wp core install \
    --url="https://${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root

  wp user create \
    "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${USER_PASS}" \
    --role=author \
    --allow-root

  chown -R www-data:www-data /var/www/html
  echo "[wordpress] WordPress ready."
fi

exec "$@"
