require 'spec_helper'
require 'find'
require 'zlib'

=begin
- Before any tests are run, read in the contents of a Gzipped compressed file containing a list of recordings
- and store the array to an instance variable

- To grab a source file:

ls /var/spool/asterisk/monitor | gzip -c | ssh deployer@test.host.com 'cat > /home/deployer/dev/engines/free_pbx/spec/fixtures/monitors.txt.gz'

- The before code:


=end

module FreePbx
  describe AsteriskMonitor do
  
    before(:all) do
      file_name = 'spec/fixtures/monitors.txt.gz'
      @file_count = `zcat -f #{file_name} | wc -l`.split[0].to_i
      raw_monitors_list = Zlib::GzipReader.new( open(file_name) ).map { |line| line.chomp }
      @monitors_list = raw_monitors_list.to_enum
    end

    subject { create(:free_pbx_asterisk_monitor) }
    
    it "has a valid factory" do
      expect(subject).to be_valid
    end


    describe "Validations" do
      %w(path uniqueid).each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end
    end  # Validations


  
    describe "#reindex" do
      before(:each) do
        # Stub and return an Enumerator of recordings from the file list fixture we have
        #   rather than reading from the actual file system
        AsteriskMonitor.stub!(:file_list).and_return(@monitors_list)
        AsteriskMonitor.reindex
      end
  
      context "is successful" do
        it "has the correct number of records created" do
          expect(AsteriskMonitor.count).to eq(@file_count)
        end
    
        it "has the correct unique ids" do
          expect(AsteriskMonitor.first.uniqueid).to eq('1353316149.33')
          expect(AsteriskMonitor.find_by_uniqueid('1354866349.14901')).to_not eq(nil)
          expect(AsteriskMonitor.find_by_uniqueid('1354866349.xxxxx')).to eq(nil)
        end
      end

      # TODO Implement this: email will be to the users in User report
      context "is not successful" do
        it "should not have the correct number of records created" do
          #expect(AsteriskMonitor.count).not_to eq(@file_count)
        end
        it "should send a notification" do
        end
      end
    
    end # reindex
  

  end
end

