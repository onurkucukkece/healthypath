class DealerMailer < ActionMailer::Base
  default from: "Watins Istatease <watkins@istatease.com>"

  def failed_path(dealer)
    @dealer = dealer
    mail(to: "Onur Kucukkece <onur.kucukkece@gmail.com>", subject: "Unhealthy dealer URL | #{@dealer.name}")
  end
end
