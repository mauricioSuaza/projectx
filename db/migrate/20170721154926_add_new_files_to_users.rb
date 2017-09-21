class AddNewFilesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :btc, :string
    add_column :users, :phone, :string
    add_column :users, :country, :string
  end
end
