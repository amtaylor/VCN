class WelcomeController < ApplicationController
  	def index
      @investors = Investor.all
      @companies = Company.all
	end
end
