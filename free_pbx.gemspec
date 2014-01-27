$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "free_pbx/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "free_pbx"
  s.version     = FreePbx::VERSION
  s.authors     = ["Robert Roach"]
  s.email       = ["rjayroach@gmail.com"]
  s.homepage    = "http://rjayroach.github.io"
  s.summary     = "GUI to FreePBX systems."
  s.description = "Description of FreePbx."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency "mcp_common"
  s.add_dependency "dry_auth"
  #s.add_dependency "mcp_mq"
#  s.add_dependency "ransack"
#  s.add_dependency "whenever"
#  s.add_dependency "will_paginate", ">= 3.0.3"
#  s.add_dependency "private_pub" #, ">= 3.0.3"
#  s.add_dependency "strong_parameters"
#  s.add_dependency "mcp_common", ">= 0.0.8"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-rails"
end
