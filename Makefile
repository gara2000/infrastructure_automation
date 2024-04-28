include automation/make
include ansible/make
include terraform/make
include docker/make

local-install:
	pip3 install --upgrade pip &&\
		pip3 install -r docker/app/requirements.txt

local-lint:
	pylint --disable=R,C docker/app/app.py

local-all: install lint