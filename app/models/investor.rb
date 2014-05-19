class Investor < ActiveRecord::Base
  belongs_to :company

	class << self
	 def company_for_investor(user, investor)
       companies = Investor.where(:name => investor.name).map(&:company).uniq
	   user.user_companies.where("company_id in (?)", companies).map(&:company)
	 end
	end

end
