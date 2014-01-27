require 'spec_helper'

module FreePbx
  describe User do

    subject { create(:free_pbx_user) }
    
    it "has a valid factory" do
      expect(create(:free_pbx_user)).to be_valid
    end

    describe "Validations" do
      %w(email_report auth).each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end
    end  # Validations


    describe "Associations" do
      it "has belongs to DryAuth::User" do
        should belong_to(:auth)
      end
    end # Assocations

  end
end

