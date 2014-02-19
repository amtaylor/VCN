class WelcomeController < ApplicationController
  	def index
      @investors = Investor.select(:name).uniq.order("name ASC")
      @companies = Company.all
	end
end
