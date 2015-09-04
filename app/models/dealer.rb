class Dealer < ActiveRecord::Base
  validates :name, :path, :website, presence: true
  WEBSITES = %w(www.hotspring.co.uk www.calderaspas.co.uk)
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
