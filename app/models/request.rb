class Request < ApplicationRecord
  
  has_many :transactions, dependent: :destroy
  belongs_to :user
  enum status: { pending: 0, completed: 1 }
  enum requested: { waiting: 0, done: 1 }
  
  after_create :set_pending
  
  private 
  
  def set_pending
    self.update(pending: self.value )
  end
  
end
