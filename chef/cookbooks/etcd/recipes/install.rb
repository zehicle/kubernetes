# Copyright 2015, RackN
# All Rights Reserved
#

etcd_url="#{node['etcd']['url']}/#{node['etcd']['version']}/etcd-#{node['etcd']['version']}-#{node['etcd']['platform']}.tar.gz"

bash "Install Etcd" do
  code <<EOC
## download, extract and update etcd binaries ##
echo 'Installing etcd...'
mkdir -p /root/downloads
cd /root/downloads
rm -rf etcd-#{node['etcd']['version']}-#{node['etcd']['platform']} || true;
curl -L #{etcd_url} -o etcd.tar.gz;
tar xzvf etcd.tar.gz && cd etcd-#{node['etcd']['version']}-#{node['etcd']['platform']};
mv -v etcd /usr/local/bin/etcd;
mv -v etcdctl /usr/local/bin/etcdctl;
EOC
  not_if { File.exists?("/usr/local/bin/etcd") }
end


