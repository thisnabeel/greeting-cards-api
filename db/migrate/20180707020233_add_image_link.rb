class AddImageLink < ActiveRecord::Migration
  def change
	add_column :products, :image_url, :string, :default => ""
  end
end
