FROM alpine
RUN apk add --no-cache libc6-compat
RUN apk add --no-cache curl unzip gcc libc-dev

WORKDIR /vlang
COPY ./v_linux.zip ./
RUN unzip -qq ./v_linux.zip

WORKDIR /source
COPY ./src ./src

RUN /vlang/v/v -prod -o ./app.exe ./src
RUN rm -rf /vlang

ENTRYPOINT ./app.exe
