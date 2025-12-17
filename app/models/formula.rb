class Formula < ActiveRecord::Base
    belongs_to :product
    has_many :materials
end
