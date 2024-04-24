install:
	pip3 install --upgrade pip &&\
		pip3 install -r src/app/requirements.txt

lint:
	pylint --disable=R,C src/app/app.py

docker-build:
	docker build -t flask-app .

docker-run:
	docker run --rm -d -p 8080:8080 --name flask-app flask-app

docker-debug:
	docker run -d -p 8080:8080 --name flask-app flask-app
	docker exec -it flask-app /bin/bash

docker-stop:
	docker rm -f flask-app

docker-all: docker-stop docker-build docker-run

docker-clean:
	docker rm -f flask-app
	docker rmi flask-app

all: install lint