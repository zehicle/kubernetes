# Copyright 2015, RackN
# All Rights Reserved
#

user 'etcd'

group 'etcd'

# Make data dir.
directory '/var/etcd' do
  owner 'etcd'
  group 'etcd'
end
data_dir = '/var/etcd'

directory '/etc/etcd' do
  owner 'etcd'
  group 'etcd'
end

# Comma separated list of names.
members = node['etcd']['nodes']

etcd_peer_port=node['etcd']['peer-port']
etcd_client_port=node['etcd']['client-port']

cluster_members=[]
members.each do |name, addr|
  cluster_members << "#{name}=http://#{addr}:#{etcd_peer_port}"
end
cluster_members = cluster_members.join(',')
cluster_token=node['etcd']['cluster-id']

# TODO: One day add security parameters

template '/etc/etcd/config' do
  source 'config.erb'
  mode 0640
  owner 'etcd'
  group 'etcd'
  variables :name => node['etcd']['name'],
            :my_ip => node['etcd']['address'],
            :data_dir => data_dir,
            :cluster_token => cluster_token,
            :cluster_members => cluster_members,
            :client_port => etcd_client_port,
            :peer_port => etcd_peer_port
end

if Dir.exists?('/etc/systemd')
  cookbook_file '/etc/systemd/system/etcd.service' do
    mode 0755
    owner 'root'
    group 'root'
    source 'etcd.service'
  end
else
  # Non-system init
  cookbook_file '/etc/init.d/etcd' do
    mode 0755
    owner 'root'
    group 'root'
    source 'etcd'
  end
end

service 'etcd' do
  action [:enable, :start]
end


