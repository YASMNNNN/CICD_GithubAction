FROM ubuntu:24.04
LABEL maintainer="Noureddine GRASSA"
RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*
CMD ["echo", "Hello from new gitomyapp!"]