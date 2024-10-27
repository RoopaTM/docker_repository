# Use an Ubuntu base image
FROM ubuntu:22.04

# Install necessary packages ----->  java maven git
RUN apt-get update && \
    apt-get install -y wget openjdk-17-jdk maven git && \
    apt-get clean

# Clone the repository
RUN git clone https://github.com/PraveenKuber/Amazon /Amazon 

# Set the working directory to where the pom.xml is located
WORKDIR /Amazon/Amazon

# Build the project with Maven
RUN mvn clean install

# Download and install Tomcat
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz && \
    tar -xzf apache-tomcat-9.0.96.tar.gz && \
    mv apache-tomcat-9.0.96 /usr/local/tomcat && \
    rm apache-tomcat-9.0.96.tar.gz

# Copy the WAR file to the Tomcat webapps directory
RUN cp /Amazon/Amazon/Amazon-Web/target/Amazon.war /usr/local/tomcat/webapps/

# Expose the port the app runs on
EXPOSE 8083
# Start Tomcat
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/catalina.sh", "run"]
