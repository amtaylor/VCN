class Investor < ActiveRecord::Base
  belongs_to :company

  class << self
  	def company_for_investor(investor)
  	  Investor.where(:name => investor.name).map(&:company).map(&:name).uniq
    end
  end

end
