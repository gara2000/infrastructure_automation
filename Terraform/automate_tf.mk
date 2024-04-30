terraform-apply:
	@echo "---------- Terraform: Building infrastructure with ------------"
	{ \
		cd Terraform ; \
		terraform init ; \
		terraform apply -auto-approve ; \
	}

terraform-destroy:
	@echo "----------- Terraform: Destroying infrastructure -------------"
	{ \
		cd Terraform ; \
		terraform destroy -auto-approve ; \
	}