#!/usr/bin/env sh

BIN_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
ROOT_DIR=$(dirname $BIN_DIR)
PRIVATE_KEY=$ROOT_DIR/.vagrant/machines/default/virtualbox/private_key
INVENTORY=$ROOT_DIR/dev-inventory.ini
PLAYBOOK=$ROOT_DIR/site.yml

cd $ROOT_DIR

export ANSIBLE_HOST_KEY_CHECKING='False'

ansible-playbook \
    -i $INVENTORY \
    --private-key=$PRIVATE_KEY \
    --sudo \
    $PLAYBOOK
