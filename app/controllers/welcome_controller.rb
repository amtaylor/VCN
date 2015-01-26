class WelcomeController < ApplicationController
	before_filter :require_companies
	before_filter :set_user_registered

  def index
    @investors = @companies.nil? || user.nil? ? [] : sorted_investor_names
  end

	def companylist
	  render :partial => 'competitorlist.html.erb'
	end

	def investorlist
	  @investors = sorted_investor_names
	  render :partial => 'investors.html.erb'
	end

	def companylistfulldata
	  render :partial => 'competitors.html.erb'
	end

	def require_companies
	  uc = Rails.cache.fetch("user:#{user.id}:companies", :force => false) do
			user.user_companies.pluck(:company_id)
		end
	  @companies = uc.nil? ? [] : Company.where('id in (?)', uc)
	end

	def set_user_registered
	  @user_registered ||= !/guest/.match(user.email)
	end

	private

	def sorted_investor_names
		UserCompany.investor_names_for_user_companies(user).uniq.sort_by { |x| x.name}
	end

end
