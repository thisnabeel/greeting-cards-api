class AddMaximum < ActiveRecord::Migration
  def change
	add_column :products, :maximum, :integer, :default => 0
	add_column :products, :group_size, :integer, :default => 1
  end
end
