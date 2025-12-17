class CreateFormulas < ActiveRecord::Migration
  def change
    create_table :formulas do |t|
      t.string :title
      t.integer :position
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
