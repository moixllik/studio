get:
	python3 ./src/get-data.py

clear:
	python3 ./src/clear-data.py

process:
	python3 ./src/process-data.py

deps:
	sudo apt install -y python3-requests \
		python3-pandas python3-nltk python3-tabulate
	rm -rf ./src/leia
	mkdir -p ./src/leia
	git clone https://github.com/rafjaa/LeIA.git ./src/leia
