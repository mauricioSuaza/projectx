class AddDonationIdToTransfer < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :donation_id, :integer
  end
end
