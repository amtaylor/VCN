class Company < ActiveRecord::Base
  has_many :investors, :dependent => :destroy
end
