#!/bin/bash
#
# Copyright 2014, Greg Althaus
#

# Get release requested
if [[ $1 = '--develop' ]]; then
  TREE="develop"
  REPO="develop"
elif [[ $1 = '--master' ]]; then
  TREE="master"
  REPO="master"
elif [[ $1 = '--release' ]]; then
  TREE="release/$2"
  REPO="release/$2"
else
  TREE="master"
  REPO="master"
fi

# Setup RackN private repo
cd /etc/yum.repos.d
cat > rackn_private.repo <<EOF
[racknprivate]
name=repo for rackn private rpms
baseurl=http://rackn.s3-website-us-east-1.amazonaws.com/private/$REPO
enabled=1
gpgcheck=0
type=none
autorefresh=1
keeppackages=1
EOF
cd -

#
# Make sure the digitalrebar is installed
#
wget --no-check-certificate -O - https://raw.githubusercontent.com/digitalrebar/core/$TREE/tools/rebar-install.sh | source /dev/stdin $@

# Install code
yum install -y rackn-kubernetes

