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
    transaction.save(validate: false)
  end

  def block_sender_and_receiver transaction
    @sender = User.find(transaction.sender_id)
    @receiver = User.find(transaction.receiver_id)
    @sender.update(blocked: true)
    transaction.update(completed: 1)
    @receiver.update(blocked: true) if transaction.invoice.present?
  end
end