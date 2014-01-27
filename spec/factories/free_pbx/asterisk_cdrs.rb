# spec/factories/asterisk_cdrs.rb
#
# FreePbx::AsteriskCdr(
# calldate: datetime
# clid: string
# src: string
# dst: string
# dcontext: string
# channel: string
# dstchannel: string
# lastapp: string
# lastdata: string
# duration: integer
# billsec: integer
# disposition: string
# amaflags: integer
# accountcode: string
# uniqueid: string
# userfield: string)


module FreePbx
  FactoryGirl.define do

    factory :free_pbx_asterisk_cdr, class: AsteriskCdr do
      ignore do
        days_ago { Date.today }
        outbound true
      end

      today
      answered
      src { rand 10000000..99999999 }
      dst { rand 10000000..99999999 }
      uniqueid { "#{rand 10000000..9999999999}.#{rand 1000..9999}" }
  
      trait :today do
        calldate { Time.at((0.day.ago.end_of_day.to_f - 0.day.ago.beginning_of_day.to_f) * rand +
                           0.day.ago.beginning_of_day.to_f) }
      end
  
      trait :yesterday do
        calldate { Time.at((1.day.ago.end_of_day.to_f - 1.day.ago.beginning_of_day.to_f) * rand +
                           1.day.ago.beginning_of_day.to_f) }
      end
  
      trait :answered do
        disposition 'ANSWERED'
        duration { rand 9..999 }
        billsec {duration - rand(3..8)}
      end

      trait :no_answer do
        disposition 'NO ANSWER'
        duration { rand 1..9 }
        billsec 0
      end

      trait :with_monitor do
        after(:create) do |instance, evaluator|
          if evaluator.outbound
            create :free_pbx_asterisk_monitor, :outbound, uniqueid: instance.uniqueid, src: instance.src
          else
            create :free_pbx_asterisk_monitor, :inbound, uniqueid: instance.uniqueid, src: instance.src
          end
        end
      end # :with_monitor

    end # :asterisk_cdr
  
  end
end



