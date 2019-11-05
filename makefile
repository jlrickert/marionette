local-workstation:
	ansible-playbook \
		--limit localhost \
		workstation.yml