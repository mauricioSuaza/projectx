class TransactionWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 10


	sidekiq_retry_in do |count|
    rand(300) * (count + 1) # (i.e. 10, 20, 30, 40, 50)
  end

	def perform(transaction_id)
    @transaction = Transaction.find(transaction_id)
    if @transaction.status == false
      if User.find(@transaction.receiver_id).has_role? :owner
        block_sender_with_admin(@transaction)
      else
        block_sender_and_receiver(@transaction)
      end
    end
  end

  def block_sender_with_admin transaction
    transaction.donation.user.update(blocked: true)
    transaction.update(completed: 1)
    #@user = User.find(transaction.receiver_id)
    #@user.update(saldo: @user.saldo + transaction.value)
    #create notificacion fallida.
  end

  def block_sender_and_receiver transaction
    transaction.donation.user.update(blocked: true)
    @receiver = User.find(transaction.receiver_id).update(blocked: true)
    transaction.update(completed: 1)
  end
end