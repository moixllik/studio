FROM alpine:latest

WORKDIR /webapp

COPY ./templates ./templates
COPY ./target/x86_64-unknown-linux-musl/release/app ./

ENTRYPOINT ./app
