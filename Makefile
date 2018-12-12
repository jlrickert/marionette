all: vagrant provision

.PHONY: vagrant
vagrant:
	@echo "Setting up base vagrant box"
	@./bin/bootstrap-vagrant.sh

.PHONY: provision
provision:
	@echo "Provisioning vagrant box with ansible"
	@./bin/provision-vagrant.sh

.PHONY: deploy_staging
deploy_staging:
