#
# Copyright 2016, RackN
#

class BarclampKubernetes::Deploy < Role

  # Make sure the that new deploy role has all the other roles as children.
  def on_node_bind(nr)

    etcd_r = Role.find_by_name('kubernetes-etcd')
    master_r = Role.find_by_name('kubernetes-master')
    node_r = Role.find_by_name('kubernetes-node')
    gw_r = Role.find_by_name('kubernetes-gateway')

    items = []
    [ etcd_r, master_r, node_r, gw_r ].each do |r|
      items << NodeRole.peers_by_role(nr.deployment, r)
    end

    items.flatten.each do |item|
      nr.add_parent(item)
    end

  end

end

