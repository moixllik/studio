IMAGE_TAG= "mongodb:server"

all:
	@echo "make [option]"

pkgs:
	pip install pymongo

# docker images
build:
	@echo "\nBUILD IMAGE"
	docker build --tag $(IMAGE_TAG) .

# docker ps
run:
	@echo "\nRUN CONTAINER"
	docker run -p 27017:27017 --detach $(IMAGE_TAG)

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

# 1 OK
test:
	@echo "\nTEST"
	@python3 ./test.py

clean: stop rm-containers rm-images
	@echo "\nCLEAN"
