class DealerMailer < ActionMailer::Base
  default from: "Watins Istatease <watkins@istatease.com>"

  def failed_path(dealers)
    @dealers = dealers
    mail(to: "Onur Kucukkece <onur.kucukkece@gmail.com>", subject: "Unhealthy dealer URLs")
  end
end
