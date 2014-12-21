FROM ubuntu:14.04
MAINTAINER Brian Ustas <brianustas@gmail.com>

RUN apt-get -y update && \
    apt-get -y install git

RUN git clone https://github.com/ustasb/emoji_soup.git /srv/www/emoji_soup && \
    rm -rf /srv/www/emoji_soup/.git

WORKDIR /srv/www/emoji_soup

VOLUME /srv/www/emoji_soup
