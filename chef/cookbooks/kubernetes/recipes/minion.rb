# Copyright 2015, RackN
# All Rights Reserved
#

include_recipe 'kubernetes::common'

master_port = node['kubernetes']['master-port']
if node['kubernetes']['master']
  master = "http://#{node['kubernetes']['address']}:#{master_port}"
else
  master = "http://#{node['kubernetes']['common_name']}:#{master_port}"
end

directory '/var/lib/kubelet' do
  user 'kube'
  group 'kube'
end

template '/etc/kubernetes/kubelet' do
  source 'kubelet.erb'
  user 'kube'
  group 'kube'
  mode 0640
  variables :master => master, :kubelet_port => node['kubernetes']['kubelet-port']
end

template '/etc/kubernetes/proxy' do
  source 'proxy.erb'
  user 'kube'
  group 'kube'
  mode 0640
end

if Dir.exists?('/etc/systemd')
  cookbook_file '/etc/systemd/system/kubelet.service' do
    mode 0644
    owner 'root'
    group 'root'
    source 'kubelet.service'
  end
  cookbook_file '/etc/systemd/system/kube-proxy.service' do
    mode 0644
    owner 'root'
    group 'root'
    source 'kube-proxy.service'
  end
else
  # Non-system init
  cookbook_file '/etc/init.d/kubelet' do
    mode 0755
    owner 'root'
    group 'root'
    source 'kubelet'
  end
  cookbook_file '/etc/init.d/kube-proxy' do
    mode 0755
    owner 'root'
    group 'root'
    source 'kube-proxy'
  end
end

service 'kubelet' do
  action [:enable, :start]
end

service 'kube-proxy' do
  action [:enable, :start]
end
