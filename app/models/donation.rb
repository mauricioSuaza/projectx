class Donation < ApplicationRecord
  # belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  # belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'

  belongs_to :user
  has_many :transactions, dependent: :destroy
  enum status: { pending: 0, completed: 1 }
  validates :value, presence: true, numericality: { greater_than: 99, less_than: 10001}

  def days_passed_since_created
    time_now = DateTime.now.to_i
    created_donation = self.created_at.to_i
    days_left = (time_now - created_donation)/86400
  end
end
