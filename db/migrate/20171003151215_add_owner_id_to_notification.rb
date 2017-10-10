class AddOwnerIdToNotification < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :transaction_id
    add_column :notifications, :owner_id, :integer
  end
end
