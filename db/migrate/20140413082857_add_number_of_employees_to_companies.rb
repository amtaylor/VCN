class AddNumberOfEmployeesToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :number_of_employees, :integer
  end
end
