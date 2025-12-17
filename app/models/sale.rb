class Sale < ActiveRecord::Base
  before_save :populate_guid
  validates_uniqueness_of :guid

  serialize :invoice

  belongs_to :product

  def usd
    return "$#{(self.amount.to_f * 0.010).to_i}"
  end

  private

  def populate_guid
    if new_record?
      while !valid? || self.guid.nil?
        self.guid = SecureRandom.random_number(1_000_000_000).to_s(36)
      end
    end
  end
end
