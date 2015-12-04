# Copyright 2015, RackN
#
# All Rights Reserved

class BarclampKubernetes::Etcd < Role

  def on_deployment_create(dr)
    DeploymentRole.transaction do
      cl_id = Attrib.get('etcd-cluster-id', dr)
      Rails.logger.info("Cluster id: currently = #{cl_id}")
      if cl_id.nil? || cl_id == ""
        Attrib.set('etcd-cluster-id', dr, BarclampKubernetes.genkey)
      end
    end
  end

  def sync_on_todo(nr)
    masters = {}
    # GREG: Use the admin network for now.
    nr.role.node_roles.where(:deployment_id => nr.deployment_id).each do |t|
      addr = t.node.addresses(:v4_only).first
      next unless addr
      etcd_name = t.node.name.split(".")[0]
      masters["#{etcd_name}"] = IP.coerce(addr).addr
    end

    Attrib.set_without_save('etcd-nodes', nr, masters)
  end

  def sysdata(nr)
    {"etcd" => {
        "name" => nr.node.name.split('.')[0],
        "address" => IP.coerce(nr.node.addresses(:v4_only).first).addr
      }
    }
  end

end
