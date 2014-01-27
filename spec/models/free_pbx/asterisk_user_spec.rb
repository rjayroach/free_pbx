require 'spec_helper'

# AsteriskUser represents an extension resource on an Asterisk/FreePBX system
# It is not related to a user from the perspective of the application
# It may be mapped and used by other resources, such as McpCall::Agent or McpPos::Register
# Other modules that re-open this class to declare those associations need to test that themselves
module FreePbx
  describe AsteriskUser do

    subject { create(:free_pbx_asterisk_user) }
    
    it "has a valid factory" do
      expect(create(:free_pbx_asterisk_user)).to be_valid
    end

    # The application does not create AsteriskUser objects
    # so validations is a empty array; Left in for documentation
    describe "Validations" do
      %w().each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end
    end  # Validations


    describe "Associations" do
      # device is the link to the actual device: sip/iax/dahdi/etc
      it "has one device" do
        expect(subject).to have_one(:asterisk_device)
      end
      it "has many inbound calls" do
        expect(subject).to have_many(:inbound_calls)
      end
      it "has many outbound calls by extension" do
        expect(subject).to have_many(:outbound_calls_by_extension)
      end
      it "has many outbound calls by outbound caller id" do
        expect(subject).to have_many(:outbound_calls_by_cid)
      end
    end  # Associations


    describe "#get_name_by_extension_or_outboundcid" do
      it "returns the name if found by extension" do
        obj = AsteriskUser.get_name_by_extension_or_outboundcid subject.extension
        expect(obj).to eq (subject.name)
      end
      it "returns the name if found by cid" do
        obj = AsteriskUser.get_name_by_extension_or_outboundcid subject.outboundcid
        expect(obj).to eq (subject.name)
      end
      it "returns 'unknown' if not found" do
        obj = AsteriskUser.get_name_by_extension_or_outboundcid 'xasb'
        expect(obj).to eq ('unknown')
      end
    end


  end
end

