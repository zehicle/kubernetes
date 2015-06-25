# Copyright 2015, RackN
# All Rights Reserved
#

user 'kube'

directory '/etc/kubernetes' do
  user 'kube'
  group 'kube'
  mode 0755
end

# Build master list http://127.0.0.1:8080
if node['kubernetes']['master']
  master = "http://#{node['kubernetes']['address']}:8080"
else
  master = "http://#{node['kubernetes']['common_name']}:8080"
end

template '/etc/kubernetes/config' do
  source 'config.erb'
  user 'kube'
  group 'kube'
  mode 0640
  variables :master => master
end