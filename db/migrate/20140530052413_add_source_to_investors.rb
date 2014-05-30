class AddSourceToInvestors < ActiveRecord::Migration
  def change
  	add_column :investors, :is_cron, :boolean, :default => false
  end
end
