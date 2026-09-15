FROM amazoncorretto:21
CMD ["./mvnw", "clean", "package"]
COPY ./build/libs/Calculator-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]