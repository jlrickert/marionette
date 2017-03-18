#!/usr/bin/env bash

export ANSIBLE_HOSTS="${PWD}/hosts"
export ANSIBLE_HOST_KEY_CHECKING='False'

vagrant up
ansible vagrant \
        -i dev-inventory.ini \
        -m raw \
        --sudo \
        --private-key=.vagrant/machines/default/virtualbox/private_key \
        -a 'pacman -Sy --needed --noconfirm ansible && sudo usermod -aG wheel vagrant'
ansible-playbook \
    site.yml \
    -i dev-inventory.ini \
    --private-key=.vagrant/machines/default/virtualbox/private_key \
    --sudo

COUNTRY='US'
URL="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&ip_version=4&use_mirror_status=on"

if /usr/bin/curl --silent --fail --output mirrorlist "${URL}"; then
    case $OSTYPE in
        darwin*)
            /usr/bin/sed -i '' 's/#Server/Server/g' mirrorlist
            ;;
        linux*)
            /usr/bin/sed -i 's/#Server/Server/g' mirrorlist
            ;;
    esac
    ansible vagrant \
            -m copy \
            -i dev-inventory.ini \
            --sudo \
            --private-key=.vagrant/machines/default/virtualbox/private_key \
            -a 'src=mirrorlist dest=/etc/pacman.d/mirrorlist owner=root group=root mode=0644 backup=yes'
    rm mirrorlist
fi
