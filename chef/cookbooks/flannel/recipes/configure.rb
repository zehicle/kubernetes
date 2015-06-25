# Copyright 2015, RackN
# All Rights Reserved
#

directory '/etc/flannel'

# Comma separated list of names.
members = node['etcd']['nodes']

etcd_client_port=4001
cluster_members=[]
members.each do |k, entry|
  cluster_members << "http://#{entry}:#{etcd_client_port}"
end

# make sure that etcd has initial subnet config.

bash 'flannel etcd config' do
  code <<EOF
etcdctl -C #{members.values.first}:#{etcd_client_port} set /coreos.com/network/config <<EOJ
{
    "Network": "#{node['flannel']['network']}",
    "SubnetLen": #{node['flannel']['subnet_size']},
    "SubnetMin": "#{node['flannel']['subnet_start']}",
    "SubnetMax": "#{node['flannel']['subnet_end']}",
    "Backend": {
        "Type": "udp",
        "Port": 7890
    }
}
EOJ
EOF
  action :run
  not_if "etcdctl -C #{members.values.first}:#{etcd_client_port} get /coreos.com/network/config"
end

template '/etc/flannel/config' do
  source 'config.erb'
  mode 0640
  owner 'root'
  group 'root'
  variables :my_ip => node['flannel']['address'],
            :etcd_endpoints => cluster_members.join(',')
end

if Dir.exists?('/etc/systemd')
  bash "reload_systemctl" do
    code "systemctl daemon-reload"
    action :nothing
  end

  cookbook_file '/etc/systemd/system/flannel.service' do
    mode 0755
    owner 'root'
    group 'root'
    source 'flannel.service'
    notifies :run, "bash[reload_systemctl]",:immediately
  end

  service 'flannel' do
    action [:enable, :start]
  end

  bash 'reload_docker' do
    code <<EOC
systemctl daemon-reload
systemctl stop docker.service
ip link delete docker0
systemctl start docker
EOC
    action :nothing
  end

  cookbook_file '/usr/lib/systemd/system/docker.service' do
    mode 0755
    owner 'root'
    group 'root'
    source 'docker.service'
    notifies :run, "bash[reload_docker]",:immediately
  end

else
  # Non-system init
  cookbook_file '/etc/init.d/flannel' do
    mode 0755
    owner 'root'
    group 'root'
    source 'flannel'
  end

  service 'flannel' do
    action [:enable, :start]
  end
end


