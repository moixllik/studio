# source ./venv/bin/activate
download:
	curl -OL https://moixllik.github.io/muchik/data/data.sqlite

run:
	uvicorn src.__main__:app --reload

pkgs:
	sudo apt update -y
	sudo apt install -y python3-venv python3-pip

venv:
	python3 -m venv venv

install:
	pip install -r requirements.txt

freeze:
	pip freeze > requirements.txt
