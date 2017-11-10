class Transaction < ApplicationRecord
  belongs_to :donation
  belongs_to :request
  has_many :notifications
  attr_accessor :invoice
  mount_uploader :invoice, InvoiceUploader
  enum completed: { pending: 0, canceled: 1 }


  filterrific(
    default_filter_params: { },
    available_filters: [ 
    :with_id,
    :value_greater_than,
    :value_lower_than
    ]
  )


  scope :with_id, lambda { |query_id|
    where('transactions.id = ?', query_id)
  }

  scope :value_greater_than, lambda { |ref_value|
    where('transactions.value >= ?', ref_value)
  }

  scope :value_lower_than, lambda { |ref_value|
    where('transactions.value < ?', ref_value)
  }


end
