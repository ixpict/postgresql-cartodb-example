# About

Samble build for cartodb postgresql-10 based on ubuntu:bionic

Use volume /data/postgresql for postgresql data.

Install the extensions:

* postgis
* plpythonu
* cartodb
* postgis_topology:
* fuzzystrmatch
* postgis_tiger_geocoder
* uuid-ossp

## Credentials

database: cartodb

username: cartodb

password: cartodb

## How to use

Run manually:

```
docker build . -t cartodb-postgresql
docker run -d -p 5432:5432 -v ${PWD}/data:/data/postgresql -v ${PWD}/log:/var/log/postgresql cartodb-postgresql
```

Or use docker-compose:

`docker-compose up -d`
