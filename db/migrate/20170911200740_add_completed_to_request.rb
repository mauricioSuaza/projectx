class AddCompletedToRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :completed, :boolean, default: false
  end
end
