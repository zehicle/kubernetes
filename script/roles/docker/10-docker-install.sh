#!/bin/bash


if [[ -f /etc/os-release ]]; then
  . /etc/os-release
fi

if ! which docker; then
    if [[ -f /etc/redhat-release || -f /etc/centos-release ]]; then
        yum -y install docker --disablerepo=extras
    elif [[ -d /etc/apt ]]; then
        # Make need extra repos
        # apt-get install -y linux-image-extra-`uname -r`
        # apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
        # sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
        # apt-get update
        apt-get install -y lxc-docker
    elif [[ -f /etc/SuSE-release ]]; then
        zypper install -y -l docker
    elif [[ "x$NAME" == "xCoreOS" ]]; then
        echo "Already installed"
    else
        die "Staged on to unknown OS media!"
    fi
fi
