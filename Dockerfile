FROM ubuntu:16.04

RUN export TERM=dumb ; \
  apt-get update && apt-get install -y \
    apt-transport-https \
  && echo "deb https://dl.bintray.com/foilen/debian stable main" > /etc/apt/sources.list.d/foilen.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 \
  && apt-get update && apt-get install -y \
    curl \
    haproxy supervisor \
    openjdk-8-jdk=8u162-b12-0ubuntu0.16.04.2 \
    james-manager=1.0.0 \
    unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl https://www.apache.org/dist/james/server/james-server-app-3.0.1-app.zip -o app.zip && \
    echo 7c3e307f27c76f1d73381d4ec11d53c60b1a84a5 app.zip > app.sha1 && \
    sha1sum -c app.sha1 && \
    unzip app.zip && \
    mv james-server-app-3.0.1/ james-server-app/ && \
    rm app.*

RUN curl https://downloads.mariadb.com/Connectors/java/connector-java-2.2.3/mariadb-java-client-2.2.3.jar -o mariadb-java-client.jar && \
    echo 3a91df529fa4367b2693ed001b53e4899a4258b4 mariadb-java-client.jar > mariadb-java-client.sha1 && \
    sha1sum -c mariadb-java-client.sha1 && \
    mv mariadb-java-client.jar /james-server-app/conf/lib/mariadb-java-client.jar && \
    rm mariadb-java-client.*

RUN useradd james && \
    mkdir -p /var/mail/ && \
    chown james:james -R /james-server-app/ /var/mail/

VOLUME /var/mail/

CMD /bin/bash
