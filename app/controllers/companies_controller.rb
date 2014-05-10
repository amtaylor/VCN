require 'crunchbase_data'
class CompaniesController < ApplicationController
  before_filter :add_companies, :only => [:create, :index]

  def index
    @companies = user.user_companies
    if @companies.empty?
      render :json => {:status => "Company Doesn't Exist"}
    else
      @investors = @companies.map(&:company).map(&:investors).first.select(:name).uniq.order("name ASC")
    end
  end

  def create
    @company = Company.find_by_name(params[:name])
    user.user_companies.create!(company_id: @company.id)
  end

  def destroy
    UserCompany.find(params[:id]).destroy
    flash[:success] = "Company deleted."

    respond_to do |format|
      format.js
    end

  end

  private

  def add_companies    
    Api::CrunchbaseData.new(params[:name], user, @company).fetch    
  end

end
