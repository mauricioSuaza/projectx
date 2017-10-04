class AddRequestedToRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :requested, :integer, :default => 0
  end
end
