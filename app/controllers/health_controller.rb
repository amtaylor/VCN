class HealthController < ApplicationController
	skip_before_filter :user

	def index
	  render :json => {status: 200}
	end
end
