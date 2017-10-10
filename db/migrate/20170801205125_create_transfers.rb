class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.decimal :value
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
