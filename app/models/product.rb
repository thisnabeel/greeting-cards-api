class Product < ActiveRecord::Base

	has_many :sales
	belongs_to :category

	has_many :formulas

	has_many :customizations

	has_one :greeting_card, dependent: :destroy

	def self.tag(tag)
		array = []
		Product.all.each do |p|
			if p.tags.present?
				if p.tags.include? tag
					array.push(p)
				end
			end
		end
		return array
	end

end
