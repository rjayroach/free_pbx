module FreePbx
  # See: http://guides.rubyonrails.org/action_mailer_basics.html
  class ReportMailer < ActionMailer::Base
    # default Hash – This is a hash of default values for any email you send, in this case we are setting the :from header to a value for all messages in this class, this can be overridden on a per email basis
    default from: "from@example.com"

    def auto_email(mail_to, attachment, report_date_range)
      @report_date_range = report_date_range
      @url = 'www.maxcole.com'
      attachments['cdrs.xls'] = File.read(attachment)

      Rails.logger.info "sending CDR report email to #{mail_to}"
      # mail – The actual email message, we are passing the :to and :subject headers in
      mail(to: mail_to, subject: 'CDR reports')
    end
  end
end
