TAGS := all
SKIP_TAGS := 
HOSTS := all
OPENVPN_CLIENTS := "[]"

all: install
	ansible-playbook --limit "$(HOSTS)" --tags "$(TAGS)" --skip-tags "$(SKIP_TAGS)"

install:
	ansible-galaxy install -r roles/requirements.yml

bootstrap:
	ansible-playbook playbooks/bootstrap.yml --tags "$(TAGS)"

openvpn-server:
	ansible-playbook openvpn/server.yml --tags "$(TAGS)"

openvpn-authority:
	ansible-playbook openvpn/authority.yml --tags "$(TAGS),authority"

openvpn-add-client:
	ansible-playbook openvpn/add_client.yml --tags "$(TAGS),client" -e "$(openvpn_clients=OPENVPN_CLIENTS)"
