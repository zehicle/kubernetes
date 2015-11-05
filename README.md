# Kubernetes Barclamp for DigitalRebar #

A Barclamp for DigitalRebar that provides the ability to create
a Kubernetes deployment.

# Use

After the node is discovered, the Kubernetes milestone role can be added to
the node.  

Remember to edit the docker-prep deployment role and change the docker-port to 0.
Kuberenetes assumes a local-only socket for docker right now.

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

