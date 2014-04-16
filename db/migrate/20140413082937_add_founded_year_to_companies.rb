class AddFoundedYearToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :founded_year, :integer
  end
end
