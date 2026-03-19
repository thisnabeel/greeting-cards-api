class MigrateFiveBySevenToSevenByTen < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE greeting_cards
      SET sheet_format = 'seven_by_ten'
      WHERE sheet_format = 'five_by_seven'
    SQL
  end

  def down
    execute <<~SQL
      UPDATE greeting_cards
      SET sheet_format = 'five_by_seven'
      WHERE sheet_format = 'seven_by_ten'
    SQL
  end
end

