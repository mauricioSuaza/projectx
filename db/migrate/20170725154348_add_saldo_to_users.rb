class AddSaldoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :saldo, :float
  end
end
