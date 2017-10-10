class AddReferralEmailToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :referral_email, :string, :default => " "
  end
end
