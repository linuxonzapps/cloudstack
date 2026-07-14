#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Extract DISTRO details for tagging
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID-$VERSION_ID"
    if [ "$VERSION_CODENAME" != "" ]; then
        DISTRO="$ID-$VERSION_CODENAME"
    fi
fi
current_dir="$PWD"
echo $DISTRO > .distro_zab.txt
apt update; apt install sudo wget -y
# CloudStack build will create *.deb packages
bash /tmp/linux-on-ibm-z-scripts/CloudStack/${version}/build_cloudstack.sh -y
tar cvfz cloudstack-${version}-linux-s390x.tar.gz *.deb
exit 0
