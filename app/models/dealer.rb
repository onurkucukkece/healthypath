class Dealer < ActiveRecord::Base

  def self.health_check
    all.each do |dealer|
      http = Net::HTTP.new("www.hotspring.co.uk/")
      response = http.request_head('/')
      dealer.update_attribute(:status, response.status)
    end
  end
end
