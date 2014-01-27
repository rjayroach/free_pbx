# spec/requests/cdrs_spec.rb
require 'spec_helper'

=begin
NOTES about importing a CDR table from a production system for testing

Before any tests are run, read in the contents of a Gzipped compressed file containing a list of CDRs

- To grab a source file:

mysqldump -uroot -psome_password asteriskcdrdb | gzip -c | ssh deployer@testing.host.com 'cat > /home/deployer/dev/engines/free_pbx/spec/factories/asteriskcdrdb.sql.gz'

- To load it run:

gunzip < /home/deployer/dev/engines/free_pbx/spec/factories/asteriskcdrdb.sql.gz | mysql -uroot -psome_password free_pbx_test

- RSpec before code:

    before(:each) do
      @magic_number_today = '90054187'
      @records_created = 45710
      # unpack a set of CDRs
      file_name = 'spec/factories/asteriskcdrdb.sql.gz'
      system "gunzip < #{file_name} | mysql -urails_mcp -prails_mcp free_pbx_test"
    end

=end


module FreePbx
  describe "Cdrs" do

    before(:each) do
      # Set Time.now to December 21, 2012 02:05:00 PM (at this instant), but allow it to move forward
      t = Time.local(2012, 12, 21, 14, 5, 0)
      Timecop.travel(t)
      @magic_number_first = '87690347'
      @magic_number_today = '90054187'
      @magic_number_yesterday = "97597825"
      @magic_number_other_day = "41356783"
      @magic_other_day = 3.days.ago
      @records_created = 48
      create(:free_pbx_asterisk_cdr, src: @magic_number_first)
      10.times { create(:free_pbx_asterisk_cdr, :no_answer, calldate: 107.days.ago) }
      3.times { create(:free_pbx_asterisk_cdr, :no_answer) }
      create(:free_pbx_asterisk_cdr, src: @magic_number_today)
      2.times { create(:free_pbx_asterisk_cdr, :yesterday) }
      17.times { create(:free_pbx_asterisk_cdr, calldate: Time.now) }
      2.times { create(:free_pbx_asterisk_cdr, calldate: @magic_other_day) }
      create(:free_pbx_asterisk_cdr, calldate: @magic_other_day, src: @magic_number_other_day)
      3.times { create(:free_pbx_asterisk_cdr, calldate: @magic_other_day) }
      create(:free_pbx_asterisk_cdr, :yesterday, src: @magic_number_yesterday)
      7.times { create(:free_pbx_asterisk_cdr, :yesterday, :no_answer) }
    end


    after(:each) do
      Timecop.return
    end


    describe "search" do
      it "has the correct number of records" do
        expect(AsteriskCdr.count).to eq(@records_created)
      end

      describe "placed today" do
        it "shows CDRs when clicked", js: true do
          visit cdrs_path
          click_link 'Today'
          expect(page).to have_content @magic_number_today
        end

        it "shows CDRs when passed param", js: true do
          visit cdrs_path(day: 'today')
          expect(page).to have_content @magic_number_today
        end
      end # placed today

      describe "placed yesterday" do
        it "shows CDRs when clicked", js: true do
          visit cdrs_path
          click_link 'Yesterday'
          expect(page).to have_content @magic_number_yesterday
        end

        it "shows CDRs when passed param", js: true do
          visit cdrs_path(day: 'yesterday')
          expect(page).to have_content @magic_number_yesterday
        end
      end # placed yesterday


      describe "placed other day" do
        it "shows CDRs when passed param", js: true do
          visit cdrs_path(day: @magic_other_day.strftime('%Y-%m-%d') )
          expect(page).to have_content @magic_number_other_day
        end
      end # placed other day


      describe "all days" do
        it "shows first CDR created", js: true do
          visit cdrs_path
          expect(page).to have_content 'Listing CDRs'
          expect(page).to have_content @magic_number_first
        end
      end # all days

    end # search


    describe "summary report methods" do
      describe "hourly" do
        it "shows hourly when clicked", js: true do
          visit cdrs_path
          click_link 'Hourly'
          expect(page).to have_content '16'
        end
      end
    end  # summary report methods


    describe "emails report" do
      it "emails the current report" do
        up1 = create(:free_pbx_user, email_report: true)
        up2 = create(:free_pbx_user, email_report: false)
        up3 = create(:free_pbx_user, email_report: true)
        visit cdrs_path(email: true, day: 'yesterday')
        expect(last_email.to).to include(up1.auth.email)
        expect(last_email.to).to_not include(up2.auth.email)
        expect(last_email.to).to include(up3.auth.email)
        expect(last_email.encoded).to include('Call Detail Records Report for date 2012-12-20')
      end
    end  # emails report


  end
end

