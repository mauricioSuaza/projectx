class AddConfirmedAtToDonations < ActiveRecord::Migration[5.0]
  def change
    add_column :donations, :confirmed_at, :datetime, :default => DateTime.now
  end
end
