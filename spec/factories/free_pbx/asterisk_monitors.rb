# spec/factories/asterisk_monitors.rb
#

module FreePbx
  FactoryGirl.define do
    factory :free_pbx_asterisk_monitor, class: AsteriskMonitor do
      ignore do
        src {rand 100..999 }  # by default, create a 3 digit extension number
        dir '/var/spool/asterisk/monitor'
      end

      uniqueid { "#{rand 10000000..9999999999}.#{rand 1000..9999}" }
      outbound

      #OUT3660-20121120-123106-1353385857.499.wav 
      trait :outbound do
        path { "#{dir}/OUT#{src}-#{Time.now.strftime('%Y%m%d')}-#{Time.now.to_i.to_s[0..6]}-#{uniqueid}.wav" }
      end

      #20121120-123106-1353385857.499.wav 
      trait :inbound do
        path { "#{dir}/#{Time.now.strftime('%Y%m%d')}-#{Time.now.to_i.to_s[0..6]}-#{uniqueid}.wav" }
      end

    end # :asterisk_monitor

  end
end
