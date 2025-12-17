class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :generic
      t.string :specific
      t.float :cost
      t.float :makes
      t.integer :position
      t.integer :formula_id

      t.timestamps null: false
    end
  end
end
