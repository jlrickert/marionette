local-workstation:
	ansible-playbook \
		--limit localhost \
		playbooks/workstation.yml

local-dotfiles:
	ansible-playbook \
		--limit localhost \
		playbooks/dotfiles.yml

deploy-server:
	ansible-playbook \
		playbooks/server.yml

deploy:
	ansible-playbook \
		playbooks/site.yml
