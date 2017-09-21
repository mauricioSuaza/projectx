class AddCompletedToDonation < ActiveRecord::Migration[5.0]
  def change
    add_column :donations, :completed, :boolean, default: false
  end
end
