class Request < ApplicationRecord
  
  has_many :transactions, dependent: :destroy
  belongs_to :user
  enum status: { pending: 0, completed: 1 }
  enum requested: { waiting: 0, done: 1 }

  validates :value, presence: true, numericality: { greater_than: 9}
  
  after_create :set_pending


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
    where('requests.id = ?', query_id)
  }

  scope :value_greater_than, lambda { |ref_value|
    where('requests.value >= ?', ref_value)
  }

  scope :value_lower_than, lambda { |ref_value|
    where('requests.value < ?', ref_value)
  }

  scope :with_user_name, lambda { |ref_name|
    Request.joins(:user).where('users.name LIKE ?', "#{ref_name}%" )
  }

  scope :with_user_email, lambda { |ref_email|
    Request.joins(:user).where('users.email LIKE ?', "#{ref_email}%" )
  }


  
  private 
  
  def set_pending
    self.update(pending: self.value )
  end

 

  
  
end
