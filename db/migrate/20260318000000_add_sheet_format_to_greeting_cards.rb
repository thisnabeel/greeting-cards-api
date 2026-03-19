class AddSheetFormatToGreetingCards < ActiveRecord::Migration[8.1]
  def change
    add_column :greeting_cards, :sheet_format, :string, null: false, default: 'letter'
  end
end

