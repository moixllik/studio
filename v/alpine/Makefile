NAME="v-app"

download:
	curl -OL https://github.com/vlang/v/releases/latest/download/v_linux.zip

build:
	@docker build -t $(NAME) .

run:
	@docker run -p 8081:8080 $(NAME)

stop:
	@docker stop $(shell docker ps -q)

clean: stop
	@docker rm $(shell docker ps -a -q)