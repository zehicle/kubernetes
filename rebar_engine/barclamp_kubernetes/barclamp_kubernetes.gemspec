$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "barclamp_kubernetes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "barclamp_kubernetes"
  s.version     = BarclampKubernetes::VERSION
  s.authors     = ["Greg Althaus"]
  s.email       = ["greg@rackn.com"]
  s.homepage    = ""
  s.summary     = " Summary of BarclampKubernetes."
  s.description = " Description of BarclampKubernetes."

  s.files = Dir["{app,config,db,lib}/**/*"] + [ "Rakefile", ]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
