# Copyright 2015, RackN
# All Rights Reserved
#

include_recipe 'kubernetes::common'

etcd_servers = []
etcd_client_port = node['etcd']['client-port']
node['etcd']['nodes'].each do |k,e|
  etcd_servers << "http://#{e}:#{etcd_client_port}"
end
cluster_ip_range=node['kubernetes']['cluster-ip-range']

template '/etc/kubernetes/apiserver' do
  source 'apiserver.erb'
  user 'kube'
  group 'kube'
  mode 0640
  variables :etcd_servers => etcd_servers.join(','),
            :cluster_ip_range => cluster_ip_range,
            :master_port => node['kubernetes']['master-port'],
            :kubelet_port => node['kubernetes']['kubelet-port']
end

template '/etc/kubernetes/controller-manager' do
  source 'controller-manager.erb'
  user 'kube'
  group 'kube'
  mode 0640
end

template '/etc/kubernetes/scheduler' do
  source 'scheduler.erb'
  user 'kube'
  group 'kube'
  mode 0640
end

if Dir.exists?('/etc/systemd')
  cookbook_file '/etc/systemd/system/kube-apiserver.service' do
    mode 0644
    owner 'root'
    group 'root'
    source 'kube-apiserver.service'
  end
  cookbook_file '/etc/systemd/system/kube-controller-manager.service' do
    mode 0644
    owner 'root'
    group 'root'
    source 'kube-controller-manager.service'
  end
  cookbook_file '/etc/systemd/system/kube-scheduler.service' do
    mode 0644
    owner 'root'
    group 'root'
    source 'kube-scheduler.service'
  end
else
  # Non-system init
  cookbook_file '/etc/init.d/kube-apiserver' do
    mode 0755
    owner 'root'
    group 'root'
    source 'kube-apiserver'
  end
  cookbook_file '/etc/init.d/kube-controller-manager' do
    mode 0755
    owner 'root'
    group 'root'
    source 'kube-controller-manager'
  end
  cookbook_file '/etc/init.d/kube-scheduler' do
    mode 0755
    owner 'root'
    group 'root'
    source 'kube-scheduler'
  end
end

service 'kube-apiserver' do
  action [:enable, :start]
end

service 'kube-controller-manager' do
  action [:enable, :start]
end

service 'kube-scheduler' do
  action [:enable, :start]
end