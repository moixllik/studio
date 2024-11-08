FROM debian:stable-slim
RUN apt update -y
RUN apt install -y python3

WORKDIR /webapp
COPY public	public

ENTRYPOINT python3 -m http.server -b 0.0.0.0 8080 -d ./public
