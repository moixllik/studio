FROM python:3.10-alpine

WORKDIR /www
COPY ./index.html ./

EXPOSE 8000
ENTRYPOINT python3 -m http.server
