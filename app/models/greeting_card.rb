class GreetingCard < ActiveRecord::Base
  belongs_to :product

  has_one_attached :front_image
  has_one_attached :inside_image

  validates :product, presence: true

  SHEET_FORMATS = %w[letter seven_by_ten].freeze

  validates :sheet_format, presence: true, inclusion: { in: SHEET_FORMATS }
end


