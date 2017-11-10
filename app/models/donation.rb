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

  filterrific(
    default_filter_params: { },
    available_filters: [ 
    :with_id,
    :value_greater_than,
    :value_lower_than,
    :with_user_name,
    :with_user_email
    ]
  )


  scope :with_id, lambda { |query_id|
    where('donations.id = ?', query_id)
  }

  scope :value_greater_than, lambda { |ref_value|
    where('donations.value >= ?', ref_value)
  }

  scope :value_lower_than, lambda { |ref_value|
    where('donations.value < ?', ref_value)
  }

  scope :with_user_name, lambda { |ref_name|
    Donation.joins(:user).where('users.name LIKE ?', "#{ref_name}%" )
  }

  scope :with_user_email, lambda { |ref_email|
    Donation.joins(:user).where('users.email LIKE ?', "#{ref_email}%" )
  }


end
