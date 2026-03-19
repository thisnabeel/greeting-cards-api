class CreateGreetingCards < ActiveRecord::Migration[8.1]
  def change
    create_table :greeting_cards do |t|
      t.references :product, null: false, index: true

      t.string :title

      t.float :front_scale
      t.float :front_offset_x
      t.float :front_offset_y

      t.float :inside_scale
      t.float :inside_offset_x
      t.float :inside_offset_y

      t.float :fold_ratio_front
      t.float :fold_ratio_inside

      t.timestamps null: false
    end
  end
end

