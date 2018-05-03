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
    james-manager=1.1.1 \
    unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -L https://dl.bintray.com/foilen/releases/james-server-app-3.1.0-871d10-SNAPSHOT-app.zip -o app.zip && \
    echo 96b94c6dfcb7c4f365198fbcf820a370fcce4cb7 app.zip > app.sha1 && \
    sha1sum -c app.sha1 && \
    unzip app.zip && \
    mv james-server-app-*/ james-server-app/ && \
    rm app.*

RUN curl -L https://dl.bintray.com/foilen/maven/com/foilen/james-extra-components/1.2.0/james-extra-components-1.2.0.jar -o james-extra-components.jar && \
    echo 681dd7a33a2d997e2dc99cb33f732afc501d7edb james-extra-components.jar > james-extra-components.jar.sha1 && \
    sha1sum -c james-extra-components.jar.sha1 && \
    mv james-extra-components.jar /james-server-app/conf/lib/james-extra-components.jar && \
    rm james-extra-components.*

RUN curl -L https://downloads.mariadb.com/Connectors/java/connector-java-2.2.3/mariadb-java-client-2.2.3.jar -o mariadb-java-client.jar && \
    echo 3a91df529fa4367b2693ed001b53e4899a4258b4 mariadb-java-client.jar > mariadb-java-client.sha1 && \
    sha1sum -c mariadb-java-client.sha1 && \
    mv mariadb-java-client.jar /james-server-app/conf/lib/mariadb-java-client.jar && \
    rm mariadb-java-client.*

RUN useradd james && \
    mkdir -p /var/mail/ && \
    chown james:james -R /james-server-app/ /var/mail/

VOLUME /var/mail/

CMD /bin/bash
