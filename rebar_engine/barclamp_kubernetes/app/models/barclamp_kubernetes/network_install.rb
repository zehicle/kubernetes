#
# Copyright 2015, RackN
#

class BarclampKubernetes::NetworkInstall < Role

  def on_proposed(nr)
    node = nr.node
    nt = Attrib.get('kubernetes-networking', node)
    nt_name = "kubernetes-#{nt}-install"
    nt_role = Role.find_by_name(nt_name)

    raise "Can't find #{nt_name} role" unless nt_role

Rails.logger.fatal("GREG: nt_name = #{nt_name}")
Rails.logger.fatal("GREG: nt_role = #{nt_role}")

    nir = NodeRole.peers_by_node_and_role(node, nt_role)
Rails.logger.fatal("GREG: nir = #{nir}")
    nir = nir.first if nir
    unless nir
      nir = nt_role.add_to_node_in_deployment(node, node.deployment)
Rails.logger.fatal("GREG: nir2 = #{nir}")
      raise "Can't create #{nt_name} node role" unless nir
    end

    nir.add_child(nr)
  end

end

