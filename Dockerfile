FROM maven:3-amazoncorretto-21-debian AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests


FROM amazoncorretto:21-al2023 AS runtime
ENV TZ=Asia/Shanghai
WORKDIR /app

# 安装 ffmpeg
COPY --from=selenium/ffmpeg:7.1 /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg

COPY --from=builder /app/target/*.jar app.jar
EXPOSE 9001
ENTRYPOINT ["java", "-jar", "app.jar"]