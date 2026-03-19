class AddPhoneAndMessageToCartInquiries < ActiveRecord::Migration[8.1]
  def change
    add_column :cart_inquiries, :phone, :string, null: false, default: ''
    add_column :cart_inquiries, :message, :text
  end
end

