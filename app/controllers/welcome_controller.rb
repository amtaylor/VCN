class WelcomeController < ApplicationController
	before_filter :require_companies
  	
  	#TODO fix by creating temporary user
  	def index  	  
  	  if @companies.nil? || current_user.nil?
  	    @investors = []	
  	  else
  	  	@investors = Investor.where(:company_id => @companies.map(&:id).compact).select(:name).uniq.order("name ASC")
  	  end
	end

	def companylist		
		render :partial => 'competitorlist.html.erb'	
	end

	def investorlist
		@investors = UserCompany.investor_names_for_user_companies(user)
		render :partial => 'investors.html.erb'	
	end

	def companylistfulldata		
		render :partial => 'competitors.html.erb'
	end

	def require_companies
	  @companies ||= @user.user_companies.map(&:company).compact
	  Rails.logger.debug "User=#{@user.inspect}, Companies=#{@companies.inspect}"
	end

end
