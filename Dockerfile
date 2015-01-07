FROM debian:wheezy

MAINTAINER Oslo Public Library "digitalutvikling@gmail.com"

ENV REFRESHED_AT 2015-01-07

RUN DEBIAN_FRONTEND=noninteractive \
      apt-get update && \
      apt-get upgrade -y && \
      apt-get install -y libdata-dump-perl

ADD /lib /root/lib
ADD /acs-proxy.pl /root/acs-proxy.pl 

WORKDIR /root

CMD ./acs-proxy.pl $LISTEN_HOST_PORT $SIPSERVER_HOST_PORT
