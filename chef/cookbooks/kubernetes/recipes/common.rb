# Copyright 2015, RackN
# All Rights Reserved
#

user 'kube'

directory '/etc/kubernetes' do
  user 'kube'
  group 'kube'
  mode 0755
end

master_port = node['kubernetes']['master-port']
if node['kubernetes']['master']
  master = "http://#{node['kubernetes']['address']}:#{master_port}"
else
  master = "http://#{node['kubernetes']['common_name']}:#{master_port}"
end

template '/etc/kubernetes/config' do
  source 'config.erb'
  user 'kube'
  group 'kube'
  mode 0640
  variables :master => master, :allow_priv => node['kubernetes']['allow-priv']
end