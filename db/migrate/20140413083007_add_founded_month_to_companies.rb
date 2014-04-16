class AddFoundedMonthToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :founded_month, :integer
  end
end
