class Message < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user

  validates_presence_of :body, :chat_id, :user_id
  mount_uploader :invoice, InvoiceUploader
  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end