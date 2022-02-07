FROM adoptopenjdk/openjdk9:jdk-9.0.4.11 as Java

RUN mkdir -p /usr/src/app
ADD . /usr/src/app
WORKDIR /usr/src/app

ARG GRUM_CLIENT_ID
ARG GRUM_CLIENT_SECRET
RUN mvn clean package

FROM adoptopenjdk/openjdk9:jdk-9.0.4.11

WORKDIR /usr/src/app
COPY --from=Java /usr/src/app/web/build /usr/src/app/web/build

EXPOSE 8080

ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-Duser.timezone=GMT+09:00", "-Djava.security.egd=file:/dev/./urandom", "-Djava.awt.headless=true", "-Dsun.net.inetaddr.ttl=0", "-Xms2048m", "-Xmx2048m", "-XX:MaxMetaspaceSize=512m","-jar","./web/build/libs/web.jar"]
