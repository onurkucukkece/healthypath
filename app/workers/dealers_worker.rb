class DealersWorker
  include Sidekiq::Worker
  sidekiq_options queue: "dealers"
  # sidekiq_options retry: false

  def perform()
    Dealer.empty_statuses
    dealers = Dealer.all.each do |dealer|
      uri = URI.parse("http://www.hotspring.co.uk/dealers/#{dealer.path}")
      response = Net::HTTP.get_response(uri)
      status = response.inspect.match(/\w+[0-9] [a-zA-Z ]+ /)
      dealer.update_attribute(:status, status)
    end
    failed_dealers = Dealer.failed_dealers
    DealerMailer.failed_path(failed_dealers).deliver_later if failed_dealers
  end
end