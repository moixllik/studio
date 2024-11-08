all:
	@echo "make [option]"

docker-service:
	sudo systemctl restart docker

compose-up:
	sudo docker compose up

compose-down:
	sudo docker compose down

version:
	sudo docker compose version
	sudo docker --version

install: pkgs
	sudo apt install -y docker-ce docker-ce-cli containerd.io

pkgs: gpg
	sudo apt remove -y docker.io
	sudo apt update -y

gpg:
	sudo apt update -y
	sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
