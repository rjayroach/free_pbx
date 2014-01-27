source "http://rubygems.org"

# Declare your gem's dependencies in free_pbx.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem "thin"
gem 'quiet_assets', group: :development

gem "mysql2"
#gem "will_paginate", ">= 3.0.3"

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem 'shoulda-matchers', :group => [:development, :test]
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem 'rails3-generators', :group => :development

#gem "jbuilder"

#group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "therubyracer", :platform => :ruby #, :group => :assets
  gem 'jquery-ui-rails' #, :group => [:assets]
#end


# Added for cucumber
group :test do
  gem 'timecop'
  gem 'spork'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'rb-inotify'
  gem 'simplecov'
#  gem 'sinatra'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner', ">= 0.9.1"
  gem 'faker'
end

#gem 'ransack'
gem 'whenever', require: false

gem "mcp_common", git: 'https://github.com/rjayroach/mcp_common', branch: 'master'
gem "dry_auth", git: 'https://github.com/rjayroach/dry_auth', branch: 'master'
#gem "mcp_mq", :path => "../../engines/mcp_mq"


gem 'pry' #, :group => [:development, :test]
gem "pry-rails" #, :group => [:development, :test]
gem "pry-doc", :group => [:development, :test]
gem "pry-nav", :group => [:development, :test]
gem "pry-stack_explorer", :group => [:development, :test]


