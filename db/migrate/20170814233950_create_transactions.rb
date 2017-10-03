class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :value
      t.references :donation, foreign_key: true
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :status, default: false 

      t.timestamps
    end
  end
end
