class AddLayersJsonToGreetingCards < ActiveRecord::Migration[8.1]
  def change
    add_column :greeting_cards, :front_layers, :jsonb, null: false, default: []
    add_column :greeting_cards, :inside_layers, :jsonb, null: false, default: []
  end
end
