require 'crunchbase_data'
class CompaniesController < ApplicationController
  before_filter :add_companies, :only => [:index]

  def index
    @companies = Rails.cache.fetch("user:#{user.id}:companies", :force => true) do
      user.user_companies.pluck(:company_id)
    end
    if @companies.empty?
      render :json => {:status => "Company Doesn't Exist"}
    else
      @investors = Company.where('id in (?)', @companies).map(&:investors).first.select(:name).uniq.order("name ASC")
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
    begin
      Api::CrunchbaseData.new(params[:name], user, false).fetch
    rescue Exception => e
      Rails.logger.debug "Exception Caught=#{e.inspect}"
      render :json => {:status => "Company Doesn't Exist"}
    end
  end

end
