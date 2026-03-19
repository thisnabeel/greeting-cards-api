class CreateCartInquiries < ActiveRecord::Migration[8.1]
  def change
    create_table :cart_inquiries do |t|
      t.string :email, null: false
      t.jsonb :cart, null: false, default: []
      t.decimal :total, null: false, default: 0, precision: 12, scale: 2
      t.string :status, null: false, default: 'new'

      t.timestamps
    end

    add_index :cart_inquiries, :created_at
  end
end

