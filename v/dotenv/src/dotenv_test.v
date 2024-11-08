module main

import os
import dotenv

fn test_hello() {
	dotenv.load()

	hello := os.getenv('HELLO')
	world := os.getenv('WORLD')

	assert 'hello=world' == hello + '=' + world
}
