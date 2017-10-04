class AddMigrationToDonations < ActiveRecord::Migration[5.0]
  def change
    remove_column :donations, :sender_id
    remove_column :donations, :recipient_id
    add_column :donations, :balance, :float
    add_column :donations, :residue, :float
    add_column :donations, :value, :float
    add_column :donations, :user_id, :integer
  end
end
