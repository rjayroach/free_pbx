
Rails.logger.info "\nLoading extensions to the User model from #{ __FILE__ }\n"

# 
# Add extensions to Authorization's User class
# See: http://stackoverflow.com/questions/2012383/extending-a-ruby-gem-in-rails
# Also, see: http://stackoverflow.com/questions/8895103/how-can-i-keep-my-initializer-configuration-from-being-lost-in-development-mode
#

# re-write the email reports map
# no linke to asterisk_user so remove that from asterisk_user if it exists
# remove user_map from teh migrations; check specs for tests
# move the factory for user to free_pbx
Rails.application.config.to_prepare do
  DryAuth::User.class_eval do
    # The nomenclature of the relation name is module_class
    # foreign_key is the attribute in the 'belongs_to' model that stores the 'has_one' model's primary key
    has_one :free_pbx_user, class_name: 'FreePbx::User', foreign_key: 'dry_auth_user_id'
    # set update_only: true otherwise calling user.update_attributes(..) will delete and insert a new record
    accepts_nested_attributes_for :free_pbx_user, update_only: true
  end
end

