#
# Copyright 2015, RackN
#

class BarclampKubernetes::Master < Role

  def on_deployment_create(dr)
    default = DnsNameFilter.find_by_name('default')
    new_template = default.template.split('.', 3)[2]

    DnsNameFilter.find_or_create_by(name: 'kube-apiserver',
                          priority: 1000,
                          matcher: 'node.role has "kubernetes-master"',
                          template: "kube-apiserver.#{new_template}",
                          service: default.service)

    DeploymentRole.transaction do
      Attrib.set('kubernetes-master-name', dr, "kube-apiserver.#{new_template}")
    end
  end

  def on_todo(nr)
    masters={}
    # GREG: Use the admin network for now.
    nr.role.node_roles.where(:deployment_id => nr.deployment_id).each do |t|
      addr = t.node.addresses(:v4_only).first
      next unless addr
      name = t.node.name.split(".")[0]
      masters["#{name}"] = IP.coerce(addr).addr
    end

    Attrib.set('kubernetes-masters', nr, masters)
  end

  def sysdata(nr)
    {"kubernetes" => {
        "master" => true,
        "name" => nr.node.name.split('.')[0],
        "address" => IP.coerce(nr.node.addresses(:v4_only).first).addr
    }
    }
  end

end

