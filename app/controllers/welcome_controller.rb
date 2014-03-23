class WelcomeController < ApplicationController
  	def index
      	@investors = Investor.select(:name).uniq.order("name ASC")
      	@companies = Company.all
	end

	def companylist
		@companies = Company.all
		render :partial => 'competitors.html.erb'	
	end

	def investorlist
		@investors = Investor.select(:name).uniq.order("name ASC")
		render :partial => 'investors.html.erb'	
	end

end
