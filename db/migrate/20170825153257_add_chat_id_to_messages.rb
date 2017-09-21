class AddChatIdToMessages < ActiveRecord::Migration[5.0]
  def change
  	remove_column :messages, :conversation_id
  	add_column :messages, :chat_id, :integer
  end
end
