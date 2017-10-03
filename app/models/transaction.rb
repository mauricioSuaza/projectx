class Transaction < ApplicationRecord
  belongs_to :donation
  belongs_to :request
  attr_accessor :invoice
  mount_uploader :invoice, InvoiceUploader

  def confirm_transaction
    #@transaction.update(sta1tus: true)
    #@sender = User.find(@transaction.sender_id)
    #@sender.update(saldo:  (@sender.saldo + (@transaction.value + (@transaction.value*0.3))))
    #redirect_to '/my_dashboard', notice: "transaction sucesfully confirmed"
    #UserWorker.perform_in(10.seconds, self.id)
  end


end
