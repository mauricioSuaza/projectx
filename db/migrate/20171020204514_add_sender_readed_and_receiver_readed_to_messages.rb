class AddSenderReadedAndReceiverReadedToMessages < ActiveRecord::Migration[5.0]
  def change
  	add_column :messages, :sender_readed, :boolean, default: false
  	add_column :messages, :receiver_readed, :boolean, default: false
  end
end
