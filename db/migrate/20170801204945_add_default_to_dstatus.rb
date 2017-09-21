class AddDefaultToDstatus < ActiveRecord::Migration[5.0]
  def change
    remove_column :donations, :status
    add_column :donations, :status, :integer, default: 0
  end
end
