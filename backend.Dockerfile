FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY . .

# Build the entire project to ensure all modules and dependencies are correctly resolved
# Using -Dmaven.test.skip=true to skip test compilation and execution
# Using -Dfile.encoding=UTF-8 to ensure character encoding
RUN mvn clean install -Dmaven.test.skip=true -Dfile.encoding=UTF-8 -s maven_settings.xml -Dmaven.wagon.http.retryHandler.count=3

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/api/scm-api/target/scm-api-*.jar app.jar

# Environment variables for default configuration
ENV SPRING_CLOUD_NACOS_CONFIG_ENABLED=false \
    SPRING_CLOUD_NACOS_DISCOVERY_ENABLED=false \
    SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/qihangerp-scm?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=GMT%2B8&allowPublicKeyRetrieval=true \
    SPRING_DATASOURCE_USERNAME=root \
    SPRING_DATASOURCE_PASSWORD=root \
    SPRING_DATA_REDIS_HOST=redis

EXPOSE 8081
CMD ["java", "-jar", "app.jar"]
