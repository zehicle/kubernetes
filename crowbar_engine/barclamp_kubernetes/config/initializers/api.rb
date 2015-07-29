# Copyright 2015, RackN
#

bc = Barclamp.table_exists? ? Barclamp.find_by_name("kubernetes") : nil
BarclampKubernetes::API_VERSION=(bc && bc.api_version || "v2")
BarclampKubernetes::API_VERSION_ACCEPTS=(bc && bc.api_version_accepts || "v2")
