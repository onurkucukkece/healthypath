class Dealer < ActiveRecord::Base
  WEBSITES = %w(www.hotspring.co.uk www.calderaspas.co.uk)
  def self.empty_statuses
    all.each do |dealer|
      dealer.update_attribute(:status, '')
    end
  end

  def self.failed_dealers
    where().not(status: '200 OK ').map do |dealer|
      [dealer.name, dealer.status]
    end
  end
end
