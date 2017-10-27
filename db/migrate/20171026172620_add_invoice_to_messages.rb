class AddInvoiceToMessages < ActiveRecord::Migration[5.0]
  def change
  	add_column :messages, :invoice, :string
  end
end
