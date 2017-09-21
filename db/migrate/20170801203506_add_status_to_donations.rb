class AddStatusToDonations < ActiveRecord::Migration[5.0]
  def change
    add_column :donations, :status, :integer
    remove_column :donations, :residue
    add_column :donations, :pending, :decimal
  end
end
