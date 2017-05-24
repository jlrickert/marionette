# marionette

Project to provision my own internal network

# Production stuff

example command to provision my server

```bash
ansible-playbook -i inventory/production.ini $playbook --private-key ~/.ssh/id_rsa
```

# Quick setup for a vagrant box

Follow https://github.com/elasticdog/packer-arch and add the virtualbox vagrant
box.

Run `make` to setup the vagrant instance and provision it.

Run `make provision` to push any changes to the vagrant box.
