class DealersWorker
  include Sidekiq::Worker
  sidekiq_options queue: "dealers"
  # sidekiq_options retry: false
  
  def perform()
    Dealer.empty_statuses
    dealers = Dealer.all.each do |dealer|
      uri = URI.parse("http://www.hotspring.co.uk/dealers/#{dealer.path}")
      response = Net::HTTP.get_response(uri)
      dealer.update_attribute(:status, response.inspect)
    end
  end
end