class AddRequestToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_reference :transactions, :request, foreign_key: true
  end
end
