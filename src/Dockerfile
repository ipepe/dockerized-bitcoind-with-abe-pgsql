FROM ubuntu:16.04
MAINTAINER docker@ipepe.pl

# instalacja podstawowych pakietow i ustawienie kodowania na UTF-8
RUN apt-get update -q && apt-get install -yq locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN echo 'LANGUAGE="en_US:en"' >> /etc/default/locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# instalacja i konfiguracja Ruby
RUN useradd -m -s /bin/bash webapp && usermod -a -G sudo webapp && \
    echo "webapp:Password1" | chpasswd && chown -R webapp:webapp "/home/webapp"

# instalacja postgres
RUN apt-get update -q && apt-get install -yq wget nano git htop sudo apt-utils curl software-properties-common
ENV PGDATA /data/db

RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
	&& chmod +x /usr/local/bin/gosu

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -q && apt-get install -yq postgresql-9.6 postgresql-contrib-9.6 postgresql-client-9.6
RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
ENV PATH /usr/lib/postgresql/9.6/bin:$PATH
RUN rm -rf /var/lib/postgresql/9.6/main

# install bitcoind
RUN sudo apt-add-repository ppa:bitcoin/bitcoin
RUN sudo apt-get update &&  sudo apt-get -y install bitcoind

#install abe
RUN apt-get update && apt-get install -y python2.7 python-crypto python-psycopg2
RUN su - webapp -c "git clone https://github.com/bitcoin-abe/bitcoin-abe.git /home/webapp/bitcoin-abe"
RUN cd /home/webapp/bitcoin-abe && python setup.py install
COPY abe-pg.conf /home/webapp/bitcoin-abe/
RUN chown webapp:webapp /home/webapp/bitcoin-abe/abe-pg.conf

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh && \
 touch /first_run.marker && \
 apt-get clean && \
 rm -rf /tmp/*

VOLUME "/data"
EXPOSE 5432 8333 2750
CMD ["/docker-entrypoint.sh"]
