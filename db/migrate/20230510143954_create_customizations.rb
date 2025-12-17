class CreateCustomizations < ActiveRecord::Migration
  def change

    create_table :customizations do |t|
      t.string :title
      t.text :description
      t.string :choices
      t.float :cost, default: 0.0
      t.integer :position
      t.integer :product_id
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
