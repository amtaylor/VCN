class CreateInvestors < ActiveRecord::Migration
  def change
    create_table :investors do |t|
      t.string :name
      t.references :company
      t.string :crunchbase_id
      t.timestamps
    end
  end
end
