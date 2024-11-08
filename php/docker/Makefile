NAME="php-app"

build:
	docker build -t $(NAME) .

run:
	docker run -p 8081:80 $(NAME)

stop:
	docker stop $(shell docker ps -q)

clean: stop
	docker rm $(shell docker ps -a -q)
