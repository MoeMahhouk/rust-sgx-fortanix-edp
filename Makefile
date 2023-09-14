build:
	sudo docker build -t fortanix-test-sgx-app .

run:
	sudo docker run --privileged --device /dev/sgx --rm -it --name fortanix-test-sgx-container fortanix-test-sgx-app

clean-images:
	echo y | docker image prune

clean-all: 
	echo y | docker system prune

.PHONY: build run clean