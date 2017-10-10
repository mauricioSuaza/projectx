class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|

      t.timestamps

      t.integer :user_id
      t.decimal :value
      t.integer :status, default: 0
      t.decimal :pending
    end
  end
end
