FROM      debian:jessie

RUN apt-get update && \
    apt-get install -y wget git golang ruby ruby-dev rubygems irb ri rdoc build-essential libssl-dev zlib1g-dev && \
    gem install fpm

# build logstash-forwarder
RUN git clone git://github.com/elasticsearch/logstash-forwarder.git /tmp/logstash-forwarder && \
    cd /tmp/logstash-forwarder && go build && \
    cd /tmp/logstash-forwarder && make deb && dpkg -i /tmp/logstash-forwarder/*.deb && \
    rm -rf /tmp/*

ADD config.json /tmp/config.json
ADD https://raw.githubusercontent.com/zhilvis/docker-logstash/master/ssl/lumberjack.crt /tmp/

CMD /opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/config.json

