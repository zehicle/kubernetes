# Copyright 2015, RackN
# All Rights Reserved
#

flannel_url="#{node['flannel']['url']}/v#{node['flannel']['version']}/flannel-#{node['flannel']['version']}-#{node['flannel']['platform']}.tar.gz"

bash "Install flannel" do
  code <<EOC
## download, extract and update flannel binaries ##
echo 'Installing flannel...'
mkdir -p /root/downloads
cd /root/downloads
rm -rf flannel-#{node['flannel']['version']} || true;
curl -L #{flannel_url} -o flannel.tar.gz;
tar xzvf flannel.tar.gz && cd flannel-#{node['flannel']['version']};
mv -v flanneld /usr/local/bin/flanneld;
EOC
  not_if { File.exists?("/usr/local/bin/flanneld") }
end


