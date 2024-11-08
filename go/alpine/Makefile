NAME="go-app"

run:
	go run src/main.go

build:
	go build -o app.exe src/main.go

init:
	go mod init studio.go/alpine

pkgs:
	go get github.com/gin-gonic/gin

build-docker:
	@docker build -t $(NAME) .

run-docker:
	@docker run -p 8081:8080 $(NAME)

stop-docker:
	@docker stop $(shell docker ps -q)

clean-docker: stop-docker
	@docker rm $(shell docker ps -a -q)