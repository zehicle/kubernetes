#
# Copyright 2015, RackN
#

class BarclampKubernetes::Minion < Role

  def sysdata(nr)
    {"kubernetes" => {
        "name" => nr.node.name.split('.')[0],
        "address" => IP.coerce(nr.node.addresses(:v4_only).first).addr
    }
    }
  end

end

