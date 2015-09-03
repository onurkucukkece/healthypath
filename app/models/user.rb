class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def self.all_user_mails
    output = ''
    all.each do |user|
      output += "#{user.fullname} <#{user.email}>,"
    end 
    return output
  end
end
