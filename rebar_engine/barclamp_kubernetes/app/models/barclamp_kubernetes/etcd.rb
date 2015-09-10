# Copyright 2015, RackN
#
# All Rights Reserved

class BarclampKubernetes::Etcd < Role

  def on_deployment_create(dr)
    DeploymentRole.transaction do
      Rails.logger.info("#{name}: Merging cluster id into #{dr.deployment.name}")
      dr.data_update({"etcd" => {"cluster-id" => BarclampKubernetes.genkey}})
      dr.commit
      Rails.logger.info("Merged.")
    end
  end

  def on_todo(nr)
    masters = {}
    # GREG: Use the admin network for now.
    nr.role.node_roles.where(:deployment_id => nr.deployment_id).each do |t|
      addr = t.node.addresses(:v4_only).first
      next unless addr
      etcd_name = t.node.name.split(".")[0]
      masters["#{etcd_name}"] = IP.coerce(addr).addr
    end

    Attrib.set('etcd-nodes', nr, masters)
  end

  def sysdata(nr)
    {"etcd" => {
        "name" => nr.node.name.split('.')[0],
        "address" => IP.coerce(nr.node.addresses(:v4_only).first).addr
      }
    }
  end

end
