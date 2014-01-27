
#namespace :db:schema:dump do
# NOTE: This code is here in dummy because it is expressly used for developing the engine
# These rake tasks will not be used in production, so they don't need to be in the engine's lib/tasks directory, rather here in dummy that does not get distributed with the gem
#
# NOTEs on use from a clean database
# mysql create test db adn grant permission
# rake free_pbx_install:migrations
# rake db:migrate
#
# This routine will NOT modify the development database
# run rake :custom:db:test:load
# This will build the schema and load it into the test db
# if there is an error in loading the schema, edit the schema and then run rake db:test:load rather than this custom:db:test:load since you don't want to regenerate the schema (just load it)
# TODO  I think cucumber creates the test database as a clone of deveopment, so this situation won't exactly work
# TODO  What might need to do is move the sqlite dev db out of the way, then create a new one from teh schema, then clone dev to test; After testing put back the original sqlite dev db
namespace :custom do
  namespace :db do
    namespace :test do

      desc "Dump schema from one or more legacy databases and load them all to development database"
      task :load do
        # TODO: test for existence of schema_orig and do not move it if it already exists; most likely cause is the last time this task was run, it didn't complete properly
        system "mv db/schema.rb db/schema_orig.rb"
        installations = %w{development asteriskcdrdb asterisk elastix_acl}
    
        installations.each do |db|
          system "rake db:schema:dump RAILS_ENV=#{db}"
          system "mv db/schema.rb db/#{db}_schema.rb"
        end
    
        installations.each do |db|
          system "cat db/#{db}_schema.rb >> db/schema.rb" 
        end
        system "rake db:test:load"
        system "mv db/schema_orig.rb db/schema.rb"
        # NOTE: if the elastix_user doesn't load, comment out the line trying to create an index
      end
    end  # :test

    namespace :asterisk do

      desc "Create test and dev tables for asterisk and asteriskcdrdb"
      task :load do
        installations = %w{asteriskcdrdb asterisk}
        installations.each do |db|
          %w(development test).each do |env|
            system "mysqldump -u rails_mcp -prails_mcp -d #{db} | mysql -u rails_mcp -prails_mcp -D#{db}_#{env}"
          end
        end
      end

    end

  end  # :db

end

