#!/usr/bin/env sh

BIN_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
ROOT_DIR=$(dirname $BIN_DIR)
COUNTRY='US'
PRIVATE_KEY=$ROOT_DIR/.vagrant/machines/default/virtualbox/private_key
INVENTORY=$ROOT_DIR/dev-inventory.ini
VAGRANT_IP=`grep -Eo "^([0-9]{3}\.){3}[0-9]{3}" $INVENTORY`

cd $ROOT_DIR

export ANSIBLE_HOST_KEY_CHECKING='False'

vagrant up

echo "Waiting for ssh server to be up"
if ! ssh -q vagrant@$VAGRANT_IP -i $PRIVATE_KEY exit; then
    echo "ssh timeout"
    exit 1;
fi

MIRROR_URL="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&ip_version=4&use_mirror_status=on"
MIRRORLIST=/tmp/${USER}/mirrorlist
mkdir -p $(dirname $MIRRORLIST)
if /usr/bin/curl --silent --fail --output "${MIRRORLIST}" "${MIRROR_URL}"; then
    case $OSTYPE in
        darwin*)
            /usr/bin/sed -i '' 's/#Server/Server/g' $MIRRORLIST
            ;;
        linux*)
            /usr/bin/sed -i 's/#Server/Server/g' $MIRRORLIST
            ;;
    esac
    echo "Updating pacman mirros"
    ansible vagrant \
            -m copy \
            -i $INVENTORY \
            --sudo \
            --private-key=$PRIVATE_KEY \
            -a "src=${MIRRORLIST} dest=/etc/pacman.d/mirrorlist owner=root group=root mode=0644 backup=yes"
    rm $MIRRORLIST
fi

echo "Ensure that ansible is present"
ansible vagrant \
        -i $INVENTORY \
        -m raw \
        --sudo \
        --private-key=$PRIVATE_KEY \
        -a 'pacman -Sy --needed --noconfirm ansible'
