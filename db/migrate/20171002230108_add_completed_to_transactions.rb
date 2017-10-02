class AddCompletedToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :completed, :integer, :default => 0
  end
end
