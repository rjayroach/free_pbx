# spec/factories/free_pbx/asterisk_users.rb

module FreePbx
  FactoryGirl.define do

    factory :free_pbx_asterisk_user, class: AsteriskUser do
      extension
      name { extension }
      outboundcid { rand 10000000..99999999 }

      trait :with_cdrs do
        after(:create) do |instance, evaluator|
          # place outbound calls today using DID - answered
          create_list(:asterisk_cdr, 40, src: instance.outboundcid)

          # place outbound calls today using DID - no answer
          create_list(:asterisk_cdr, 10, :no_answer, src: instance.outboundcid)

          # receive inbound calls today - answered
          create_list(:asterisk_cdr, 3, dst: instance.extension)

          # receive inbound calls today - not answered
          create_list(:asterisk_cdr, 2, :no_answer, dst: instance.extension)
        end
      end # :with_cdrs

      trait :with_cdrs_and_monitors do
        after(:create) do |instance, evaluator|
          # place outbound calls today using DID - answered
          create_list(:asterisk_cdr, 40, :with_monitor, src: instance.outboundcid)

          # place outbound calls today using DID - no answer
          create_list(:asterisk_cdr, 10, :no_answer, src: instance.outboundcid)

          # receive inbound calls today - answered
          create_list(:asterisk_cdr, 3, :with_monitor, dst: instance.extension)

          # receive inbound calls today - not answered
          create_list(:asterisk_cdr, 2, :no_answer, dst: instance.extension)
        end
      end
    end
  
    sequence :extension do |n|
      "10#{n}"
    end

  end
end

