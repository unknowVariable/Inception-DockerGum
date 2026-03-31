#!/bin/sh
set -eu

: "${MYSQL_DATABASE:?MYSQL_DATABASE manquant}"
: "${MYSQL_USER:?MYSQL_USER manquant}"

ROOT_PW="$(cat /run/secrets/db_root_password)"
USER_PW="$(cat /run/secrets/db_password)"

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql "${DATADIR}" || true

if [ ! -d "${DATADIR}/mysql" ]; then
  echo "[mariadb] Initialisation du datadir..."
  mariadb-install-db --user=mysql --datadir="${DATADIR}" >/dev/null
fi

echo "[mariadb] Démarrage temporaire..."
mariadbd --user=mysql --datadir="${DATADIR}" --skip-networking --socket="${SOCKET}" &
pid="$!"

i=0
while ! mariadb-admin --socket="${SOCKET}" ping --silent >/dev/null 2>&1; do
  i=$((i+1))
  if [ "$i" -ge 60 ]; then
    echo "[mariadb] Timeout au démarrage"
    kill "$pid" || true
    exit 1
  fi
  sleep 1
done

sql_exec() {
  if mariadb --socket="${SOCKET}" -uroot -p"${ROOT_PW}" -e "SELECT 1;" >/dev/null 2>&1; then
    mariadb --socket="${SOCKET}" -uroot -p"${ROOT_PW}" "$@"
  else
    mariadb --socket="${SOCKET}" -uroot "$@"
  fi
}

echo "[mariadb] Création / vérification DB et user..."
sql_exec << EOFSQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${USER_PW}';
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${USER_PW}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PW}';
FLUSH PRIVILEGES;
EOFSQL

echo "[mariadb] Arrêt temporaire..."
mariadb-admin --socket="${SOCKET}" -uroot -p"${ROOT_PW}" shutdown
wait "$pid" || true

echo "[mariadb] Démarrage final..."
exec "$@"
