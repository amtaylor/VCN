class AddTotalMoneyRaisedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :total_money_raised, :string
  end
end
