class AddTransactionToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :transaction_value, :decimal
  end
end
