class UserCompany < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  scope :funded_recently, -> {where("created_at > ?", Time.now.at_midnight)}

  class << self
  	def investor_names_for_user_companies(user)
      companies = user.user_companies.map(&:company)
      return [] if companies.empty?
      investors = companies.map(&:investors)
      return [] if investors.empty?
      investors.first.select(:name).uniq
  	end
  end
end
