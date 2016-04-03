require 'spec_helper'

module FreePbx
  describe AsteriskCdr do

    subject { create(:free_pbx_asterisk_cdr) }

    before(:each) do
      t = Time.local(2012, 12, 21, 14, 5, 0)
      Timecop.travel(t)
    end

    after(:each) do
      Timecop.return
    end

    # The records are generated from an external system, so we don't validate the records
    # Here the validations are testing whether the factory is generating appropriate records
    # TODO: Update FactoryGirl and use the built in linter for validating factory is an MVO
    describe "Validations" do
      it "generates correct factories" do
        expect(subject.calldate).to_not be_blank
        expect(subject.src).to_not be_blank
        expect(subject.dst).to_not be_blank
        expect(subject.duration).to_not be_blank
        expect(subject.disposition).to_not be_blank
        expect(subject.uniqueid).to_not be_blank
        #expect(AsteriskCdr.all).to match_array([])
      end
    end  # Validations

    describe "search" do
      before(:each) do
        3.times { create(:free_pbx_asterisk_cdr) }
        4.times { create(:free_pbx_asterisk_cdr, :yesterday) }
        5.times { create(:free_pbx_asterisk_cdr, calldate: 2.days.ago) }
      end


      it "filters records by today" do
        params = AsteriskCdr.ransack_params_for(:today)
        search = AsteriskCdr.search(params)
        expect(search.result.count).to eq(3)
      end

      it "filters recrods by yesterday" do
        params = AsteriskCdr.ransack_params_for(:yesterday)
        search = AsteriskCdr.search(params)
        expect(search.result.count).to eq(4)
      end

      it "filters recrods by yesterday" do
        params = AsteriskCdr.ransack_params_for(2.days.ago.to_s.split[0])
        search = AsteriskCdr.search(params)
        expect(search.result.count).to eq(5)
      end
    end


    describe "supporting methods" do

      it "sums the duration by hour" do
        a = []
        a << Time.now.utc.hour
        3.times { create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: Time.now) }
        report = AsteriskCdr.group_by_hour
        s = report.map(&:hour)
        expect(report.size).to eq(1)
        expect(report.map(&:hour)).to match_array(a)
      end

      it "sums the duration by src,hour" do
        create(:free_pbx_asterisk_user, extension: '101')
        create(:free_pbx_asterisk_user, extension: '102')
        3.times { create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: Time.now) }
        3.times { create(:free_pbx_asterisk_cdr, :answered, src: '102', duration: 100, calldate: Time.now) }
        expect(AsteriskCdr.count).to eq (6)
        report = AsteriskCdr.joins_asterisk_users_by_src.group_by_src_and_hour
        s = report.map(&:hour)
        expect(report.size).to eq(2)
      end

    end # supporting methods


    describe "summary report methods" do

      describe "#calls_by_hour" do
        it "sums the duration" do
          create(:free_pbx_asterisk_user, extension: '101')
          create(:free_pbx_asterisk_user, extension: '102')
          3.times { create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: Time.now) }
          3.times { create(:free_pbx_asterisk_cdr, :answered, src: '102', duration: 100, calldate: Time.now) }
          expect(AsteriskCdr.count).to eq (6)
          search = AsteriskCdr.search( AsteriskCdr.ransack_params_for(:today) )
          report = AsteriskCdr.calls_by_hour search
          s = report.map(&:hour)
          expect(report.size).to eq(1)
        end
      end


      describe "#calls_by_hour_and_agent" do
        it "sums the duration" do
          create(:free_pbx_asterisk_user, extension: '101')
          create(:free_pbx_asterisk_user, extension: '102')
          3.times { create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: Time.now) }
          3.times { create(:free_pbx_asterisk_cdr, :answered, src: '102', duration: 100, calldate: Time.now) }
          expect(AsteriskCdr.count).to eq (6)
          search = AsteriskCdr.search( AsteriskCdr.ransack_params_for(:today) )
          report = AsteriskCdr.calls_by_hour_and_agent search
          s = report.map(&:hour)
          expect(report.size).to eq(2)
        end
      end


      describe "#first_and_last" do
        it "reports the first and last call of the day for each agent" do
          times = []
          times << []
          times << []
          min_time1 = 1.hours.ago.to_s
          min_time2 = 4.hours.ago.to_s
          now_time = Time.now.utc
          max_time1 = 3.hours.from_now.to_s
          max_time2 = 2.hours.from_now.to_s
          times[0] << ['101', min_time1]
          times[0] << ['101', max_time1]
          times[1] << ['102', min_time2]
          times[1] << ['102', max_time2]
          create(:free_pbx_asterisk_user, extension: '101')
          create(:free_pbx_asterisk_user, extension: '102')
          2.times { create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: Time.now) }
          create(:free_pbx_asterisk_cdr, :answered, src: '102', duration: 100, calldate: max_time2)
          create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: max_time1)
          3.times { create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: Time.now) }
          create(:free_pbx_asterisk_cdr, :answered, src: '102', duration: 100, calldate: min_time2)
          5.times { create(:free_pbx_asterisk_cdr, :answered, src: '102', duration: 100, calldate: Time.now) }
          create(:free_pbx_asterisk_cdr, :answered, src: '101', duration: 100, calldate: min_time1)
          3.times { create(:free_pbx_asterisk_cdr, :answered, src: '102', duration: 100, calldate: Time.now) }
          search = AsteriskCdr.search( AsteriskCdr.ransack_params_for(:today) )
          expect(AsteriskCdr.first_and_last( search )[0][0].map(&:to_s)).to match_array(times[0][0])
          expect(AsteriskCdr.first_and_last( search )[0][1].map(&:to_s)).to match_array(times[0][1])
          expect(AsteriskCdr.first_and_last( search )[1][0].map(&:to_s)).to match_array(times[1][0])
          expect(AsteriskCdr.first_and_last( search )[1][1].map(&:to_s)).to match_array(times[1][1])
        end
      end

      describe "#inbound_call_disposition" do
        it "summarizes Inbound Call Disposition" do
          u = create(:free_pbx_asterisk_user, extension: '101')
          5.times { create(:free_pbx_asterisk_cdr, :answered, dst: '101') }
          3.times { create(:free_pbx_asterisk_cdr, :no_answer, dst: '101') }
          a = {"ANSWERED"=>5, "NO ANSWER"=>3}
          search = AsteriskCdr.search( AsteriskCdr.ransack_params_for(:today) )
          report = AsteriskCdr.inbound_call_disposition search
          expect(report.count).to include(a)
        end
      end

    end # summary report methods
  end
end
