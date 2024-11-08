NAME=alpine:webapp

run:
	cargo run

pkgs:
	sudo apt install -y musl-tools
	rustup target add x86_64-unknown-linux-musl

build:
	cargo build --release --target x86_64-unknown-linux-musl

build-docker:
	sudo docker build -t $(NAME) ./

run-docker:
	sudo docker run --rm -d -p 8081:8080 -t $(NAME)

clean-docker:
	@for id in $(shell docker ps -a -q); do \
	   docker stop $$id; \
	   docker rm $$id; \
	done
	@for id in $(shell docker images -q); do \
		docker rmi $$id; \
	done
