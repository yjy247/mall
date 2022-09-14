FROM openjdk:8-jdk-alpine

ARG PROJECT_NAME
ARG WORKSPACE

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone 
VOLUME /tmp

ENV MYSQL_HOST=192.168.195.129
ADD ./mall-admin/target/*.jar app.jar
 
ENTRYPOINT ["java","-jar","app.jar","-XX:+UnlockExperimentalVMOptions","XX:+UseCGroupMemoryLimitForHeap"]


