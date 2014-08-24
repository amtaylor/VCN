class Investor < ActiveRecord::Base
  belongs_to :company

	class << self
	 def companies_for_investor(user, investor)
     companies = Investor.where(:name => investor.name).map(&:company).uniq.map(&:id)
	   cached_user_companies(user).where("company_id in (?)", companies).map(&:company)
	 end

   private

   def cached_user_companies(user)
     Rails.cache.fetch("user:#{user.id}:companies") do
       user.user_companies
     end
   end
	end
end
