class HealthController < ApplicationController
	skip_before_filter :user

	def index
	  render :json => {status: 200, description: "Who do you think I am? R2D2?"}
	end
end
