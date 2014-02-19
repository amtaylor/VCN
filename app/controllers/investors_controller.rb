class InvestorsController < ApplicationController

  def index
    @investors = Investor.select(:name).uniq.order("name ASC")
  end
end
