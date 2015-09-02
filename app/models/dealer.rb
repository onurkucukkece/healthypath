class Dealer < ActiveRecord::Base
  def self.empty_statuses
    all.each do |dealer|
      dealer.update_attribute(:status, '')
    end
  end
end
