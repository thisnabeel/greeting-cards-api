class AddProductToSale < ActiveRecord::Migration
  def change
    add_reference :sales, :product, index: true
  end
end
