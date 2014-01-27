# spec/factories/free_pbx/users.rb

module FreePbx
  FactoryGirl.define do
    factory :free_pbx_user, class: User do
      email_report false
      association :auth, factory: :dry_auth_user
    end
  end
end

