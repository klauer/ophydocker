CONTAINER=ophydocker

image: Dockerfile
	eval $(docker-machine env)
	docker build -t ${CONTAINER} .

run: image
	docker run -d ${CONTAINER}

attach: run
	docker run -it ophydocker /bin/bash --login
