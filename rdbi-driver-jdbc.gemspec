Gem::Specification.new do |s|
  s.name        = "rdbi-driver-jdbc"
  s.version     = "0.1.0"
  s.platform    = "java"
  s.authors     = ["Shane Emmons"]
  s.email       = "semmons99@gmail.com"
  s.homepage    = "https://github.com/semmons99/rdbi-driver-jdbc"
  s.summary     = "JDBC driver for RDBI"
  s.description = "This gem gives you the ability to query JDBC connections with RDBI."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "rdbi", "~> 1"

  s.add_development_dependency "rdbi-dbrc", "~> 0.1"
  s.add_development_dependency "rspec",     "~> 2"
  s.add_development_dependency "yard"

  s.files        = Dir.glob("lib/**/*") + %w(CHANGELOG.md LICENSE README.md)
  s.require_path = "lib"
end
