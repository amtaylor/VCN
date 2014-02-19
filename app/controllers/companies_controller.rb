require 'crunchbase_data'
class CompaniesController < ApplicationController
  before_filter :require_company, :only => [:index]
  before_filter :add_companies, :only => [:index]

  def index
    if @company
      @investors = Investor.select(:name).uniq
    else
      render :json => {:status => "Company Doesn't Exist"}
    end
  end

  private

  def require_company
    Rails.logger.debug "Params=#{params}"
    return "Need company name" unless params[:name]
    @company = Company.find_by_name(params[:name])
  end

  def add_companies
    if @company.nil?
      begin
        Api::CrunchbaseData.new(params[:name]).fetch
        @company = Company.find_by_name(params[:name])
      rescue => e
        @company = nil
      end
    end
  end

end
