FROM ubuntu:14.04
MAINTAINER Jeremy Derr <jeremy@derr.me>

RUN apt-get update -qq; apt-get install -yq mysql-client awscli

ADD backup.sh /backup.sh

CMD /backup.sh
