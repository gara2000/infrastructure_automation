local-install:
	pip3 install --upgrade pip &&\
		pip3 install -r src/app/requirements.txt

local-lint:
	pylint --disable=R,C src/app/app.py

local-all: install lint

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

infra-build:
	@echo "---------- Building Infrastructure ----------"
	automation/build_infra.sh
	@echo "---------- Infrastructure Built -------------"

infra-connect:
	@echo "---------- Connecting to EC2 isntance ----------"
	automation/connect_to_instance.sh

infra-clean:
	@echo "---------- Destroying Infrastructure ----------"
	automation/clean_infra.sh
	@echo "---------- Infrastructure Destroyed -----------"

infra-all: infra-clean infra-build infra-connect

ansible-configure:
	@echo "---------- Provisioning EC2 instance ----------"
	{ \
		cd ansible ; \
		./set_node_address.sh ; \
		ansible-playbook --ask-become-pass playbooks/bootstrap.yml ; \
		ansible-playbook --ask-become-pass playbooks/docker.yml ; \
	}
	@echo "------- Finished Instance Provisioning --------"

ansible-runner-config:
	@echo "----------- Configuring Runner ------------------"
	{ \
		cd ansible ; \
		./set_runner_token.sh ; \
		ansible-playbook playbooks/runner.yml ; \
	}
	@echo "---------- Finished Runner configuration ---------"

ansible-all: ansible-configure ansible-runner-config

all: infra-clean infra-build ansible-configure ansible-runner-config