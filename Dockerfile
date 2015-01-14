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

ENV USE_LOCAL_MODS false

EXPOSE 6001

CMD USE_LOCAL_MODS=$USE_LOCAL_MODS ./acs-proxy.pl 0.0.0.0:6001 $SIPSERVER_HOST_PORT
