class UserCompany < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  scope :funded_recently, -> {where("created_at > ?", Time.now.at_midnight)}

  after_create  :purge_company_cache
  after_destroy :purge_company_cache

  class << self
  	def investor_names_for_user_companies(user)
      companies = companies_for(user).map(&:company_id)
      return [] if companies.empty?
      investor_names_for(companies)
  	end

    private

    def companies_for(user, force = false)
      Rails.cache.fetch("user:#{user.id}:companies", :force => force) do
        user.user_companies
      end
    end

    def investor_names_for(companies)
      Investor.where("company_id in (?)", companies).select(:name).order("name ASC")
    end

  end

  private

  def purge_company_cache
    Rails.cache.delete("user:#{self.user.id}:companies")
  end
  
end
