class CreateDesigns < ActiveRecord::Migration[8.0]
  def change
    create_table :designs do |t|
      t.string :name, null: false, default: 'Untitled'
      t.integer :width, null: false, default: 1080
      t.integer :height, null: false, default: 1920
      t.float :base_scale, null: false, default: 1.0
      t.float :base_offset_x, null: false, default: 0.0
      t.float :base_offset_y, null: false, default: 0.0
      t.jsonb :layers, null: false, default: []

      t.timestamps
    end
  end
end
