all:
	@echo "make [option]"

.PHONY: build test

pkgs:

build:
	v -prod -b wasm  -os browser -o ./build/module.wasm ./src
	v -prod -shared -b wasm -os wasi -o ./build/lib.wasm ./lib

server:
	python3 -m http.server

test:
	wasmer inspect ./build/module.wasm

	wasmer inspect ./build/lib.wasm
	wasmer run ./build/lib.wasm --invoke add -- 1 2
