FROM ubuntu:bionic

WORKDIR /carto

COPY . /carto

EXPOSE 5432

VOLUME /data/postgresql