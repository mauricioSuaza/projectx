class UserWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 10


	sidekiq_retry_in do |count|
    rand(300) * (count + 1) # (i.e. 10, 20, 30, 40, 50)
  end

	def perform(transaction_id)
    @transaction = Transaction.find(transaction_id)
    @transaction.update(status: true)
    @sender = User.find(@transaction.sender_id)
    @sender.update(saldo: (@sender.saldo + (@transaction.value)))   
	end
end