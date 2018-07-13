FROM ubuntu:rolling
MAINTAINER Ham Jin<jinham335908093@gmail.com>
#Port Open
EXPOSE 9200
# china timezone
RUN echo "Asia/Shanghai" > /etc/timezone

# install compiler, dependencies, tools , dnsmasq
RUN apt-get update && apt-get install -y \
    curl wget unzip docker.io \
    && rm -rf /var/lib/apt/lists/*

# Get eiblog
RUN wget https://github.com/eiblog/eiblog/archive/master.zip\
    && unzip master.zip \
    && cd eiblog-master \
    && mv conf/es /es \
    && cd ..\ 
    && rm -rf eiblog-master \
    && mkdir eiblog \
    && mkdir eiblog/conf \
    && mv es eiblog/conf/es 

# Get Elasticsearch image and run container
RUN docker pull elasticsearch:2.4.1 \
    docker run -d --name eisearch \
    -p 9200:9200 \
    -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
    -v /eiblog/conf/es/config:/usr/share/elasticsearch/config \
    -v /eiblog/conf/es/plugins:/usr/share/elasticsearch/plugins \
    elasticsearch:2.4.1

CMD ["docker start eisearch"]
CMD ["docker logs eisearch"]














