#
# Copyright 2015, RackN
#

class BarclampKubernetes::Master < Role

  def on_deployment_create(dr)
    default = DnsNameFilter.find_by_name('default')
    if default
      new_template = "kube-apiserver.#{default.template.split('.', 3)[2]}"
    else
      new_template = 'kube-apiserver.local'
    end

    DeploymentRole.transaction do
      name = Attrib.get('kubernetes-master-name',dr)
      if name.nil? || name == ""
        Attrib.set('kubernetes-master-name', dr, new_template)
      else
        return true
      end
    end

    DnsNameFilter.find_or_create_by(name: 'kube-apiserver',
                          priority: 1000,
                          matcher: 'node.role has "kubernetes-master"',
                          template: new_template,
                          service: default.service)
  end

  def sync_on_todo(nr)
    masters={}
    # GREG: Use the admin network for now.
    nr.role.node_roles.where(:deployment_id => nr.deployment_id).each do |t|
      addr = t.node.addresses(:v4_only).first
      next unless addr
      name = t.node.name.split(".")[0]
      masters["#{name}"] = IP.coerce(addr).addr
    end

    Attrib.set_without_save('kubernetes-masters', nr, masters)
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

