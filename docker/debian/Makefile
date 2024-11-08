IMAGE_TAG= "debian:webapp"

all:
	@echo "make [option]"

# docker images
build:
	@echo "\nBUILD IMAGE"
	docker build --tag $(IMAGE_TAG) .

# docker ps
run:
	@echo "\nRUN CONTAINER"
	docker run -p 8080:8080 --detach $(IMAGE_TAG)

# docker ps
stop:
	@echo "\nSTOP CONTAINERS"
	@for container in $$(docker ps -q); do \
		echo "$$container ... stop"; \
		docker stop $$container; \
	done

# docker ps -a
rm-containers:
	@echo "\nREMOVE CONTAINERS"
	@for container in $$(docker ps -a -q); do \
		echo "$$container ... remove"; \
		docker rm $$container; \
	done

# docker images
rm-images:
	@echo "\nREMOVE IMAGES"
	@for image in $$(docker images -a -q); do \
		echo "$$image ... remove"; \
		docker rmi $$image; \
	done

# 200 OK
test:
	@echo "\nTEST"
	@curl -I localhost:8080

clean: stop rm-containers rm-images
	@echo "\nCLEAN"