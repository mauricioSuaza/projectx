class AddValueToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :value, :decimal
  end
end
