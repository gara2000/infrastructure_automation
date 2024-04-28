auto-build:
	@echo "---------- Building Infrastructure ----------"
	automation/build_infra.sh
	@echo "---------- Infrastructure Built -------------"

auto-connect:
	@echo "---------- Connecting to EC2 isntance ----------"
	automation/connect_to_instance.sh

auto-clean:
	@echo "---------- Destroying Infrastructure ----------"
	automation/clean_infra.sh
	@echo "---------- Infrastructure Destroyed -----------"

auto-all: infra-clean infra-build infra-connect