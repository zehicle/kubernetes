#
# Copyright 2016, RackN
#

class BarclampKubernetes::Gateway < Role

  # Make sure the that new node role has deploy as a child.
  def on_node_bind(nr)
    r = Role.find_by_name('kubernetes-deploy')
    items = NodeRole.peers_by_role(nr.deployment, r)
    items.each do |item|
        nr.add_child(item)
    end
  end

end

