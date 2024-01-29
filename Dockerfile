FROM openjdk:8
ADD target/demo-workshop-2.1.2.jar myttrend.jar
ENTRYPOINT ["java", "-jar", "myttrend.jar"]
