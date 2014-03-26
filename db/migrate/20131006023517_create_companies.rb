class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :crunchbase_id
      t.boolean :exited, :default => false
      t.timestamps
    end
  end
end
