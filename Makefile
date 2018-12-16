all: vagrant

vagrant:
	vagrant destroy --force
	vagrant up

staging:
	ANSIBLE_HOST_KEY_CHECKING=False \
		ansible-playbook \
			-i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
			playbooks/site.yml

deploy:
	ansible-playbook -i /etc/ansible/hosts playbooks/site.yml
