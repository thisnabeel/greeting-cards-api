class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :email
      t.string :guid
      t.string :stripe_id
      t.integer :amount
      t.timestamps null: false
    end
  end
end
