class Chat < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'

  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, :scope => :recipient_id

  scope :between, -> (sender_id,recipient_id) do
    where("(chats.sender_id = ? AND chats.recipient_id =?) OR (chats.sender_id = ? AND chats.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end
end