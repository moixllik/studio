IMAGE_NAME= wasm/hello
RUNTIME= io.containerd.wasmer.v1

all:
	@echo "make [option]"

.PHONY: build

pkgs:
	sudo apt install -y emscripten

run: build
	@echo "\nRUN CONTAINER"
	docker run --runtime=$(RUNTIME) --platform=wasi/wasm $(IMAGE_NAME)

run-c: build-c
	./build/app.exe

build: build-wasm
	@echo "\nBUILD IMAGE"
	docker buildx build --platform wasi/wasm -t $(IMAGE_NAME) .
	docker push $(IMAGE_NAME)

build-c: extra
	gcc -o ./build/app.exe ./src/main.c

build-wasm: extra
	emcc ./src/main.c -s WASM=1 -o ./build/app.wasm -s STANDALONE_WASM

extra:
	mkdir -p build
