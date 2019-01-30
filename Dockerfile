FROM ubuntu:18.04

RUN export TERM=dumb ; \
  apt-get update && apt-get install -y \
    apt-transport-https ca-certificates gnupg \
  && echo "deb https://dl.bintray.com/foilen/debian stable main" > /etc/apt/sources.list.d/foilen.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 \
  && apt-get update && apt-get install -y \
    curl \
    haproxy supervisor \
    openjdk-8-jre=8u191-b12-0ubuntu0.18.04.1 \
    james-manager=1.1.2 \
    spamassassin=3.4.2-0ubuntu0.18.04.1 \
    less vim unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -L http://apache.forsale.plus/james/server/3.2.0/james-server-app-3.2.0-app.zip -o app.zip && \
    echo 58c495f6c683f4448149178cf6fff588c060d25d app.zip > app.sha1 && \
    sha1sum -c app.sha1 && \
    unzip app.zip && \
    mv james-server-app-*/ james-server-app/ && \
    rm app.*

RUN curl -L https://dl.bintray.com/foilen/maven/com/foilen/james-extra-components/1.3.2-3.2.0/james-extra-components-1.3.2-3.2.0.jar -o james-extra-components.jar && \
    echo b65d0cb614bd23809ba6fe543cb451d79b96f86c james-extra-components.jar > james-extra-components.jar.sha1 && \
    sha1sum -c james-extra-components.jar.sha1 && \
    mv james-extra-components.jar /james-server-app/conf/lib/james-extra-components.jar && \
    rm james-extra-components.*

RUN curl -L https://downloads.mariadb.com/Connectors/java/connector-java-2.3.0/mariadb-java-client-2.3.0.jar -o mariadb-java-client.jar && \
    echo c2b1a6002a169757d0649449288e9b3b776af76b mariadb-java-client.jar > mariadb-java-client.sha1 && \
    sha1sum -c mariadb-java-client.sha1 && \
    mv mariadb-java-client.jar /james-server-app/conf/lib/mariadb-java-client.jar && \
    rm mariadb-java-client.*

RUN useradd james && \
    mkdir -p /var/mail/ && \
    chown james:james -R /james-server-app/ /var/mail/

VOLUME /var/mail/

CMD /bin/bash
