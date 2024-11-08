FROM alpine

RUN apk add --no-cache libc6-compat

WORKDIR /webapp
COPY ./app.exe .

ENTRYPOINT ./app.exe