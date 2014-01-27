
module FreePbx
  class User < ActiveRecord::Base
    # foreign_key is the attribute in the 'belongs_to' model that stores the 'has_one' model's primary key
    belongs_to :auth, class_name: 'DryAuth::User', foreign_key: 'dry_auth_user_id'
    validates_presence_of :auth
    validates :email_report, inclusion: {in: [true, false]}
  end
end

