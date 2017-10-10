class Transaction < ApplicationRecord
  belongs_to :donation
  belongs_to :request
  has_many :notifications
  attr_accessor :invoice
  mount_uploader :invoice, InvoiceUploader
  enum completed: { pending: 0, canceled: 1 }
end
