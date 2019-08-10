FROM ubuntu:bionic

WORKDIR /carto

COPY *.deb /carto/

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -q -y postgresql-10 postgresql-10-postgis-2.4 \
    postgresql-plpython-10 postgresql-10-postgis-2.4-scripts locales sudo && \
    dpkg -i *.deb && rm -rf /var/lib/apt/lists/* && mkdir -p /data/postgresql && \
    chown -R postgres:postgres /data/postgresql

RUN locale-gen en_US.UTF-8 && update-locale

ENV TZ Etc\UTC
ENV LC_ALL en_US.UTF-8

COPY *.conf /carto/
COPY docker-entrypoint.sh /carto/

EXPOSE 5432

VOLUME /data/postgresql
VOLUME /var/log/postgresql

ENTRYPOINT "/carto/docker-entrypoint.sh"
