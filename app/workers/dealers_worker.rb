class DealersWorker
  include Sidekiq::Worker
  sidekiq_options queue: "dealers"
  # sidekiq_options retry: false
  
  def perform()
    dealers = Dealer.all.each do |dealer|
      http = Net::HTTP.new("www.hotspring.co.uk/dealers#{dealer.path}")
      response = http.request_head('/')
      dealer.update_attribute(:status, response.status)
    end
  end
end