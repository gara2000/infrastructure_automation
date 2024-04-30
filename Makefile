include automation/automate_script.mk
include ansible/ansible.mk
include Terraform/automate_tf.mk
include docker/docker.mk

local-install:
	pip3 install --upgrade pip &&\
		pip3 install -r docker/app/requirements.txt

local-lint:
	pylint --disable=R,C docker/app/app.py

local-all: install lint