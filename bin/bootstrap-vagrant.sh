#!/usr/bin/env sh

BIN_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
ROOT_DIR=$(dirname $BIN_DIR)
COUNTRY='US'
PRIVATE_KEY=$ROOT_DIR/.vagrant/machines/default/virtualbox/private_key
INVENTORY=$ROOT_DIR/dev-inventory.ini

cd $ROOT_DIR

export ANSIBLE_HOST_KEY_CHECKING='False'

vagrant up
sleep 2 # make sure ssh is up and running

MIRROR_URL="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&ip_version=4&use_mirror_status=on"
if /usr/bin/curl --silent --fail --output mirrorlist "${MIRROR_URL}"; then
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
            -i $INVENTORY \
            --sudo \
            --private-key=$PRIVATE_KEY \
            -a 'src=mirrorlist dest=/etc/pacman.d/mirrorlist owner=root group=root mode=0644 backup=yes'
    rm mirrorlist
fi

ansible vagrant \
        -i $INVENTORY \
        -m raw \
        --sudo \
        --private-key=$PRIVATE_KEY \
        -a 'pacman -Sy --needed --noconfirm ansible'
