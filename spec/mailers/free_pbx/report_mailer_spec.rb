require "spec_helper"

module FreePbx
  describe ReportMailer do
=begin
    xit "emails user when report is requested" do
      u = create(:user)
      email_attachment = '/tmp/ha.txt'
      File.open(email_attachment, "w"){|f| f << 'hello' }
      email = ReportMailer.auto_email(u.email, email_attachment).deliver
      expect(email.encoded).to include('Call Detail Records Report for 2013-02-16')
      #visit free_pbx.cdrs_path
      #visit cdrs_path
    end
=end
  end
end

