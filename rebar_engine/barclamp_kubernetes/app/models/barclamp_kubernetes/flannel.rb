# Copyright 2015, RackN
#
# All Rights Reserved

class BarclampKubernetes::Flannel < Role

  def sysdata(nr)
    # GREG: Use admin address for now.
    {"flannel" => {
        "address" => (IP.coerce(nr.node.addresses(:v4_only).first).addr rescue "0.0.0.0")
      }
    }
  end

end
