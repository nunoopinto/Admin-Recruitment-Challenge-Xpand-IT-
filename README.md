# Admin Recruitment Challenge

This project demonstrates how to build a Docker container with Apache Tomcat, SSL certificates and a sample web application. The container will be ready to run and expose HTTPS traffic with the necessary certificates.

## Requirements

- Docker installed on your machine.

## How to Build and Run the Docker Container

### 1. Build the Docker image

Build the Docker image by running the following command in the project directory where the `Dockerfile` is located:

```bash
docker build -t admin-challenge .
```

This command will:

- Download and install Tomcat.
- Generate a self-signed SSL certificate.
- Configure Tomcat to use the SSL certificate on port 4041.
- Expose the Tomcat sample application.

### 2. Run the Docker container

After the build process completes, you can run the Docker container with the following command:

```bash
docker run -p 4041:4041 admin-challenge
```

This will start the Tomcat server inside the Docker container and expose port 4041 on port 4041 of your machine.

### 3. Access the Sample Application

You can now access the Tomcat app via HTTPS in your browser:

```bash
https://localhost:4041/sample/
```

You may encounter a security warning because the SSL certificate is self-signed. You can ignore this warning and proceed to access the app.

### 4. Stop the Docker container

To stop the running container, simply use the command:

```bash
docker stop <container_id>
```

## Conclusion

After running the above commands, the Docker container will automatically start and expose the sample application via HTTPS. No additional manual steps are needed to access the application.
