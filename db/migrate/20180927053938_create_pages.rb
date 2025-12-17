class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
    	t.string :code
    	t.text :post
    end
  end
end
