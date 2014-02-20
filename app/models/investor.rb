class Investor < ActiveRecord::Base
  belongs_to :company

	class << self
	 def company_for_investor(investor)
     	#Investor.where(:name => investor.name).map(&:company).map(&:name).uniq #This gives back array of strings of company names
	 	Investor.where(:name => investor.name).map(&:company).uniq #This gives back array of objects of companies
	 end
	end

end
