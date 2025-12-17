class AddRequestToSale < ActiveRecord::Migration
  def change
  	add_column :sales, :requests, :text
  	add_column :sales, :phone_number, :string
  end
end
