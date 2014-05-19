class UserCompany < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  scope :funded_recently, -> {where("created_at > ?", Time.now.at_midnight)}

  class << self
  	def investor_names_for_user_companies(user)
      companies = user.user_companies.map(&:company_id)
      return [] if companies.empty?
      Investor.where("company_id in (?)", companies).select(:name).order("name ASC")
  	end
  end
end
