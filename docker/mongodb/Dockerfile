FROM debian:stable-slim
RUN apt update -y
RUN apt install -y curl

RUN curl -OL https://repo.mongodb.org/apt/debian/dists/bookworm/mongodb-org/7.0/main/binary-amd64/mongodb-org-server_7.0.12_amd64.deb

RUN apt install -y ./*.deb
RUN rm -f *.deb

RUN mkdir -p /data
ENTRYPOINT mongod --bind_ip_all --ipv6 --port 27017 --dbpath /data