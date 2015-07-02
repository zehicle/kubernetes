# Kubernetes Barclamp for OpenCrowbar #

A Barclamp for OpenCrowbar that provides the ability to create
a Kubernetes deployment.

# Install

Read this whole paragraph, please. 

1. The install script takes the same parameters as the core opencrowbar install.sh script.  That can be found [here](https://github.com/opencrowbar/core/blob/develop/doc/deployment-guide/Install-CentOS-RHEL-6.6-AdminNode.md).

2. yum install -y curl 

3. `curl -sL --user "RACKN_ID:RACKN_PSWD"
   https://raw.githubusercontent.com/rackn/kubernetes/develop/tools/kubernetes-install.sh | source /dev/stdin --develop`

3. Optional: You may run other opencrowbar install scripts as needed. 

4. cd /opt/opencrowbar/core/

5. ./production.sh &lt;FQDN of the admin node&gt;

# Use

After the node is discovered, the Kubernetes milestone role can be added to
the node.  

A number of masters can be added for redundancy levels.
Minions can be added as well.

In generel, masters and minions should be separate, but can be run
together.

Etcd, flannel, and docker will be installed as needed.

FLANNEL CONFIG HERE>!!!

# License

RackN Inc.  All rights reserved.

Experimental and non-commerical use permitted.
Without express permission for use, RackN assumes no warrenty or liability.
May be superceded by other commercial RackN licenses.

