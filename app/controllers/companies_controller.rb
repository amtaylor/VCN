require 'crunchbase_data'
class CompaniesController < ApplicationController
  before_filter :add_companies, :only => [:index]

  def index
    @companies = user.user_companies
    if @companies.empty?
      render :json => {:status => "Company Doesn't Exist"}
    else
      @investors = @companies.map(&:company).map(&:investors).first.select(:name).uniq.order("name ASC")
    end
  end

  def destroy
    company = @user.user_companies.where(:company_id => params[:id]).first
    if company.nil?
      flash[:error] = "Company doesn't exist" 
    else
      company.destroy
      flash[:success] = "Company deleted."
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def add_companies    
    Api::CrunchbaseData.new(params[:name], user, @company).fetch    
  end

end
