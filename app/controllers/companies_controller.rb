require 'crunchbase_data'
class CompaniesController < ApplicationController
  before_filter :add_companies, :only => [:index]
  before_filter :require_company, :only => [:index]

  def index
    if @company
      @investors = current_user.user_companies.where("company_id = ? ", @company.id).first.company.investors.select(:name).uniq.order("name ASC")
    else
      render :json => {:status => "Company Doesn't Exist"}
    end
  end

  def destroy
    Company.find(params[:id]).destroy
    flash[:success] = "Company deleted."

    respond_to do |format|
      format.js
    end

  end

  private

  def require_company    
    return "Need company name" unless params[:name]
    @company = Company.find_by_name(params[:name])    
  end

  def add_companies    
    Api::CrunchbaseData.new(params[:name], current_user, @company).fetch    
  end

end
