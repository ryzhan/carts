FROM java:openjdk-8-alpine

WORKDIR /usr/src/app
COPY ./target/*.jar ./app.jar
ARG DB_NETWORK_IP=db-server 

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/urandom","-Ddb:carts-db=$DB_NETWORK_DB","-jar","./app.jar", "--port=80"]
