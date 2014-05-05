class WelcomeController < ApplicationController
  	
  	#TODO fix by creating temporary user
  	def index
  	  @companies = current_user.nil? ? [] : current_user.user_companies.map(&:company).compact  	    	  
  	  if @companies.nil? || current_user.nil?
  	    @investors = []	
  	  else
  	  	@investors = Investor.where(:company_id => @companies.map(&:id).compact).select(:name).uniq.order("name ASC")
  	  end
	end

	def companylist
		@companies = Company.all
		render :partial => 'competitorlist.html.erb'	
	end

	def investorlist
		@investors = Investor.select(:name).uniq.order("name ASC")
		render :partial => 'investors.html.erb'	
	end

	def companylistfulldata
		@companies = Company.all
		render :partial => 'competitors.html.erb'
	end

end
