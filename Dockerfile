# dump build stage
FROM postgres:15-alpine as dumper

LABEL author="👍"
LABEL description="Postgres Image with tables"
LABEL version="1.0"

COPY prepopulate_carthage.sql /docker-entrypoint-initdb.d/prepopulate.sql

RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=pgpwd
ENV PGDATA=/data

RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

# final build stage
FROM postgres:15-alpine 
EXPOSE 5432
COPY --from=dumper /data $PGDATA