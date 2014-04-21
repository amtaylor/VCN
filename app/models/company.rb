class Company < ActiveRecord::Base
  has_many :investors, :dependent => :destroy
  default_scope :order => 'companies.name ASC' #added to list companies in alphabetical order
end
