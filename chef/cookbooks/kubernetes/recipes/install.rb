# Copyright 2015, RackN
# All Rights Reserved
#

kubernetes_url="#{node['kubernetes']['url']}/#{node['kubernetes']['version']}/kubernetes.tar.gz"

bash "Install kubernetes" do
  code <<EOC
## download, extract and update kubernetes binaries ##
echo 'Installing kubernetes...'
mkdir -p /root/downloads
cd /root/downloads
rm -rf kubernetes-#{node['kubernetes']['version']}-#{node['kubernetes']['platform']} || true;
curl -L #{kubernetes_url} -o kubernetes.tar.gz;
tar xzvf kubernetes.tar.gz && cd kubernetes;
cd server
tar zxvf kubernetes-server-linux-amd64.tar.gz && cd kubernetes/server/bin
cp hyperkube /usr/local/bin
cp kube-apiserver /usr/local/bin
cp kube-controller-manager /usr/local/bin
cp kubectl /usr/local/bin
cp kubelet /usr/local/bin
cp kube-proxy /usr/local/bin
cp kubernetes /usr/local/bin
cp kube-scheduler /usr/local/bin
chmod 755 /usr/local/bin/kube* /usr/local/bin/hyperkube
EOC
  not_if { File.exists?("/usr/local/bin/kubernetes") }
end


