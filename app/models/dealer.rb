class Dealer < ActiveRecord::Base
  validates :name, :path, :website, presence: true
  WEBSITES = %w(www.hotspring.co.uk www.hotspring.fr www.hotspring.nl www.calderaspas.co.uk www.calderaspas.fr www.calderaspas.de www.calderaspas.at www.calderaspas.ch www.calderaspas.se www.calderaspas.nl)
  def self.empty_statuses
    all.each do |dealer|
      dealer.update_attribute(:status, '')
    end
  end

  def self.failed_dealers
    where().not(status: '200 OK ').map do |dealer|
      [dealer.name, dealer.status, dealer.website, dealer.path]
    end
  end
end
