


# From: http://railscasts.com/episodes/275-how-i-test?view=asciicast


module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end
end


