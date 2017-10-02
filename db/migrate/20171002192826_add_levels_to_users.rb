class AddLevelsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :level_one_amount, :decimal, :default => 0
    add_column :users, :level_two_amount, :decimal, :default => 0
    add_column :users, :level_three_amount, :decimal, :default => 0
    add_column :users, :level_four_amount, :decimal, :default => 0
    add_column :users, :level_five_amount, :decimal, :default => 0
    add_column :users, :level_six_amount, :decimal, :default => 0
  end
end
