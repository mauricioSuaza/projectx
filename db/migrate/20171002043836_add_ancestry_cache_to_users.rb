class AddAncestryCacheToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ancestry_depth, :integer, :default => 0
  end
end
