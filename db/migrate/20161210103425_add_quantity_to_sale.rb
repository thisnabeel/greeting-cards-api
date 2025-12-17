class AddQuantityToSale < ActiveRecord::Migration
  def change
  	add_column :sales, :quantity, :integer, :default => 0
  end
end
