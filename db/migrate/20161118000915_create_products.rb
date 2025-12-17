class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
    	t.string :title
    	t.text :description
    	t.integer :price
    	t.integer :minimum
    end
  end
end
