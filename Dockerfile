# Базовый образ с Java 17
FROM openjdk:17-jdk-slim

# Установка рабочей директории
WORKDIR /app

# Копирование JAR-файла (сгенерированного Maven)
COPY target/APIGateway-0.0.1-SNAPSHOT.jar app.jar

# Порт, который будет использоваться сервисом
EXPOSE 8080

# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]