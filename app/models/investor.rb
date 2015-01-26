class Investor < ActiveRecord::Base
  belongs_to :company

	class << self
	 def companies_for_investor(user, investor)
     companies = Investor.where(:name => investor.name).map(&:company_id)
     Company.where('id in (?)', companies & cached_user_companies(user))	   
	 end

   private

   def cached_user_companies(user)
     Rails.cache.fetch("user:#{user.id}:companies") do
       user.user_companies.pluck(:company_id)
     end
   end
	end
end
