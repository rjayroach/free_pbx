
require 'fileutils'

namespace :custom do
  namespace :db do
    task :remove_migrations do
      FileUtils.rm_rf Dir.glob("db/migrate/*.rb") if Dir.pwd.split('/').last.eql? 'dummy'
    end
    desc "Dump schema from one or more legacy databases and load them all to development database"
    task :reset => ['custom:db:remove_migrations', 'db:drop', 'db:create', 'railties:install:migrations', 'db:migrate', 'db:seed', 'db:test:prepare'] do
      p 'done'
    end
  end
end



