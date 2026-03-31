FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server mariadb-client ca-certificates tzdata \
 && rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh \
 && mkdir -p /run/mysqld \
 && chown -R mysql:mysql /run/mysqld /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mariadbd", "--user=mysql", "--console"]
