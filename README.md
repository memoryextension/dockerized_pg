# dockerized_pg
Sample Postgresql container with preloaded database, tables and data

== docker

docker image build . -t preloaded_db:latest
docker container run -d --rm -p 5435:5432 --name test_preloaded_db preloaded_db:latest

== connect to test
psql -h localhost -U postgres -p 5435

== schema

database carthage

Has tables:

public.client: list of clients

public.library: a client has zero or more data libraries associated to him. A library has a dedicated folder for its attachements.

A library is composed of zero or more JSONB records (in table public.record)
and zero or more attachements (saved on disk 'somewhere', recorded in table public.attachment

check prepopulate_carthage.sql for exact schema.