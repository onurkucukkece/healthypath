class DealerMailer < ActionMailer::Base
  helper :application
  default from: "Watkins Istatease <watkins@istatease.com>"

  def failed_path(dealers)
    @dealers = dealers
    mail(to: User.all_user_mails, subject: "Unhealthy dealer URLs")
  end
end
