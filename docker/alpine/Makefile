IMAGE_TAG= 'alpine:webapp'

all:
	@echo "make [option]"

# docker images
build:
	docker build --tag $(IMAGE_TAG) .

# docker ps
run:
	docker run -p 8080:8080 --detach $(IMAGE_TAG)

# docker ps -a
stop:
	docker ps -q | xargs docker stop

# 200 OK
test:
	@curl -I localhost:8080

clean: stop
	docker ps -a -q | xargs docker rm
	docker images -a -q | xargs docker rmi