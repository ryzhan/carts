FROM java:openjdk-8-alpine

WORKDIR /usr/src/app
COPY ./target/*.jar ./app.jar
ARG DB_NETWORK_IP=db-server 
RUN echo $DB_NETWORK_DB

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/urandom","-Ddb:carts-db=10.142.15.223","-jar","./app.jar", "--port=80"]
