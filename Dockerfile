FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y libxslt-dev libxml2-dev openssh-client rsync ca-certificates libssl-dev build-essential

RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libcurl4-gnutls-dev 
RUN apt-get install -y libcurl4-nss-dev 

RUN apt-get install -y ruby-full

ADD "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2004-x86_64-100.3.1.deb" "/package/mongodb-database-tools-ubuntu2004-x86_64-100.3.1.deb"
RUN apt-get install -y /package/mongodb-database-tools-ubuntu2004-x86_64-100.3.1.deb

RUN gem install bundler
RUN bundle config --global silence_root_warning 1

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN mkdir /backup
VOLUME /backup

ADD . /app
WORKDIR /app

RUN bundle install --without development test

ENV BACKUP_NAME="MongoDB backup"
CMD bundle exec ruby worker.rb
