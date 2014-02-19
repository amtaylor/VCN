class Investor < ActiveRecord::Base
  belongs_to :company

	class << self
	 def company_for_investor(investor)
	   Investor.where(:name => investor.name).uniq.map(&:companies).map(&:name).order("name ASC")
	 end
	end

end
