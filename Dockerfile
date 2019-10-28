FROM java:openjdk-8-alpine

WORKDIR /usr/src/app
COPY ./target/*.jar ./app.jar
ARG DB_NETWORK_IP=db-server 
RUN export DB_NETWORK_IP=$DB_NETWORK_IP

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/urandom","-Ddb:carts-db=$DB_NETWORK_IP","-jar","./app.jar", "--port=80"]
