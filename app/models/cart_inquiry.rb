class CartInquiry < ActiveRecord::Base
  validates :email, presence: true
  validates :phone, presence: true

  validate :email_format

  private

  def email_format
    return if email.blank?

    # Lightweight format validation (not RFC-perfect).
    unless email.match?(/\A[^@\s]+@[^@\s]+\z/)
      errors.add(:email, 'is invalid')
    end
  end
end

