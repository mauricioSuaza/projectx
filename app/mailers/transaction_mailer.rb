class TransactionMailer < ApplicationMailer

  def transaction_created_reciver(transaction)
    @value = transaction.value
    @sender = User.find(transaction.sender_id)
    @receiver = User.find(transaction.receiver_id)
    mail(to: @receiver.email, subject: 'Nueva Transacción')
  end

  def transaction_created_sender(transaction)
    @value = transaction.value
    @sender = User.find(transaction.sender_id)
    @receiver = User.find(transaction.receiver_id)
    mail(to: @sender.email, subject: 'Nueva Transacción')
  end

 	def transaction_with_owner(transaction)
 		@sender = User.find(transaction.sender_id).email
 		@receiver = User.find(transaction.receiver_id)
 		@value = transaction.value
 		mail(to: @sender, subject: 'Nueva Transacción')
 	end

  def transaction_invoice(transaction)
  	@receiver = User.find(transaction.receiver_id).email
  	mail(to: @receiver, subject: 'Imagen Transacción')
  end

  def transaction_confirm(transaction)
  	@sender = User.find(transaction.sender_id).email
  	@receiver = User.find(transaction.receiver_id).email
  	mail(to: @sender, subject: 'Transacción confirmada')
  end
end
