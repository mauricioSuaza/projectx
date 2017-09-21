class AddRequestedToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :requested, :boolean
  end
end
