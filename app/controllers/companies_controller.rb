class CompaniesController < ApplicationController
  before_filter :require_company, :only => [:show]

  def show
    @investors = @company.investors
  end

  private

  def require_company
    Rails.logger.debug "Params=#{params}"
    return "Need company id" unless params[:id]
    @company = Company.find(params[:id])
  end

end
