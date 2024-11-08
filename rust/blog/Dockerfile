FROM debian:stable-slim
RUN apt -y update
RUN apt -y install openssl ca-certificates

WORKDIR webapp
COPY target/release/app .
COPY public             public
COPY templates          templates

ENTRYPOINT ./app