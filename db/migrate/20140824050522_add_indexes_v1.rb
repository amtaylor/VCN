class AddIndexesV1 < ActiveRecord::Migration
  def change
    add_index :companies, :name, unique: true
    add_index :investors, :name
    add_index :investors, :company_id
    add_index :user_companies, :user_id
    add_index :user_companies, :company_id
    add_index :user_companies, [:user_id, :company_id], unique: true
  end
end
