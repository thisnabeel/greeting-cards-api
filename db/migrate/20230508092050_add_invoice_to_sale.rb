class AddInvoiceToSale < ActiveRecord::Migration
  def change
	  add_column :sales, :invoice, :text, default: []
  end
end
