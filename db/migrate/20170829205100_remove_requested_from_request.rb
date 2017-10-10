class RemoveRequestedFromRequest < ActiveRecord::Migration[5.0]
  def change
    remove_column :requests, :requested, :boolean
  end
end
